//
//  ColorExtractionManager.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import UIKit
import SwiftUI

class ColorExtractionManager {
    
    static let shared = ColorExtractionManager()
    private init(){}
    class ColorExtractionManager {
        
        /// 원하는 비트 수 (예: 4비트)
        let bitsPerChannel: UInt8 = 4
        
        /// 이미지에서 색상을 추출하고 가중치를 적용하여 정렬한 색상 정보를 반환합니다.
        func extractColors(from image: UIImage, detectedObjects: [DetectedObject], labelWeights: [String: Double]) -> [ColorInfo] {
            
            guard let pixelData = image.pixelData(), let cgImage = image.cgImage else {
                return []
            }
            
            let width = Int(cgImage.width)
            let height = Int(cgImage.height)
            let bytesPerPixel = 4
            let bytesPerRow = bytesPerPixel * width
            
            var colorCounts: [UInt32: Double] = [:] // 색상 키와 가중치가 적용된 카운트
            
            // 바운딩 박스와 label 별 가중치를 준비합니다.
            var boxesWithWeights: [(box: CGRect, weight: Double)] = []
            for object in detectedObjects {
                let label = object.label
                let weight = labelWeights[label] ?? 1.2 // 해당 레이블의 가중치, 기본값은 1.2
                boxesWithWeights.append((box: object.boundingBox, weight: weight))
            }
            
            // 각 채널에 대한 시프트 연산 계산
            let shiftAmount = UInt8(8 - bitsPerChannel)
            let maxChannelValue = UInt8((1 << bitsPerChannel) - 1)
            
            // 픽셀 데이터를 순회합니다.
            for y in 0..<height {
                for x in 0..<width {
                    let pixelIndex = y * bytesPerRow + x * bytesPerPixel
                    let r = pixelData[pixelIndex]
                    let g = pixelData[pixelIndex + 1]
                    let b = pixelData[pixelIndex + 2]
                    let a = pixelData[pixelIndex + 3]
                    
                    // 투명한 픽셀은 건너뜁니다.
                    if a == 0 { continue }
                    
                    // 색상 양자화 적용
                    let quantizedR = (r >> shiftAmount) & maxChannelValue
                    let quantizedG = (g >> shiftAmount) & maxChannelValue
                    let quantizedB = (b >> shiftAmount) & maxChannelValue
                    let quantizedA = (a >> shiftAmount) & maxChannelValue
                    
                    // UIColor 생성
                    let color = UIColor(
                        red: CGFloat(quantizedR) / CGFloat(maxChannelValue),
                        green: CGFloat(quantizedG) / CGFloat(maxChannelValue),
                        blue: CGFloat(quantizedB) / CGFloat(maxChannelValue),
                        alpha: CGFloat(quantizedA) / CGFloat(maxChannelValue)
                    )
                    
                    // 좌표 변환 (UIKit과 Core Graphics 좌표계 차이 보정)
                    let adjustedY = height - y - 1
                    let point = CGPoint(x: x, y: adjustedY)
                    
                    var maxWeight: Double = 1.0 // 기본 가중치
                    
                    // 모든 바운딩 박스를 확인하여 최대 가중치를 찾습니다.
                    for (box, weight) in boxesWithWeights {
                        if box.contains(point) {
                            maxWeight = max(maxWeight, weight)
                            // break를 사용하지 않으므로 모든 바운딩 박스를 검사합니다.
                        }
                    }
                    
                    // **채도 계산 및 가중치 조정**
                    let saturation = color.saturation
                    let saturationWeight = Double(saturation)
                    
                    // 채도가 낮은 색상에 대한 가중치를 낮춤
                    maxWeight *= saturationWeight
                    
                    // 색상을 키로 만듭니다.
                    let colorKey = color.quantizedColorKey(bitsPerChannel: bitsPerChannel)
                    
                    // 색상 카운트에 가중치를 적용합니다.
                    colorCounts[colorKey, default: 0.0] += maxWeight
                }
            }
            
            // 전체 가중치 합계를 계산합니다.
            let totalWeightedCounts = colorCounts.values.reduce(0, +)
            var colorInfos: [ColorInfo] = []
            
            // 각 색상의 퍼센티지를 계산하고 `ColorInfo` 배열을 생성합니다.
            for (colorKey, count) in colorCounts {
                let percentage = (count / totalWeightedCounts) * 100
                
                // 양자화된 색상을 원래 범위로 변환
                let quantizedR = UInt8((colorKey >> 24) & 0xFF)
                let quantizedG = UInt8((colorKey >> 16) & 0xFF)
                let quantizedB = UInt8((colorKey >> 8) & 0xFF)
                let quantizedA = UInt8(colorKey & 0xFF)
                
                // 원래 색상 범위로 복원
                let r = CGFloat(quantizedR) / CGFloat(maxChannelValue)
                let g = CGFloat(quantizedG) / CGFloat(maxChannelValue)
                let b = CGFloat(quantizedB) / CGFloat(maxChannelValue)
                let a = CGFloat(quantizedA) / CGFloat(maxChannelValue)
                
                let color = Color(red: r, green: g, blue: b, opacity: a)
                colorInfos.append(ColorInfo(color: color, percentage: percentage))
            }
            
            // 퍼센티지에 따라 내림차순으로 정렬합니다.
            colorInfos.sort { $0.percentage > $1.percentage }
            
            return colorInfos
        }
        
        /// RGB 값이 흰색 또는 검은색인지 판단하는 메서드
        private func isBlackOrWhite(r: UInt8, g: UInt8, b: UInt8) -> Bool {
            // 흰색과 검은색을 판단하는 임계값 설정 (양자화된 값 기준)
            let threshold: UInt8 = 2 // 필요에 따라 조정
            let maxChannelValue = UInt8((1 << bitsPerChannel) - 1)
            
            let isBlack = r < threshold && g < threshold && b < threshold
            let isWhite = r > (maxChannelValue - threshold) && g > (maxChannelValue - threshold) && b > (maxChannelValue - threshold)
            
            return isBlack || isWhite
        }
        
 
        /// 정렬된 색상 리스트에서 빈도와 거리를 고려하여 색상을 선택하는 메서드
        func selectDistinctColors(from colors: [ColorInfo], count: Int = 3, distanceThreshold: Double = 80.0, frequencyThreshold: Double = 0.2) -> [ColorInfo] {
            guard !colors.isEmpty else { return [] }
            
            // 빈도 임계값 이상인 색상만 필터링
            var filteredColors = colors.filter { $0.percentage >= frequencyThreshold }
            
            // 빈도 임계값을 만족하는 색상이 없으면 임계값을 낮춤
            var frequencyThreshold = frequencyThreshold
            while filteredColors.isEmpty && frequencyThreshold > 0 {
                frequencyThreshold -= 0.5
                filteredColors = colors.filter { $0.percentage >= frequencyThreshold }
            }
            
            // 선택된 색상을 저장할 배열
            var selectedColors: [ColorInfo] = []
            
            // 첫 번째로 빈도가 높은 색상을 추가
            if let firstColor = filteredColors.first {
                selectedColors.append(firstColor)
            }
            
            // 거리 임계값을 동적으로 조정
            var distanceThreshold = distanceThreshold
            
            while selectedColors.count < count && distanceThreshold > 0 {
                for colorInfo in filteredColors {
                    // 이미 선택된 색상은 건너뜀
                    if selectedColors.contains(where: { $0.color == colorInfo.color }) {
                        continue
                    }
                    
                    // 이미 선택된 색상들과의 최소 거리 계산
                    let minDistance = selectedColors.map { self.colorDistanceLab($0.color, colorInfo.color) }.min() ?? 0
                    
                    // 거리 임계값 이상이면 선택
                    if minDistance >= distanceThreshold {
                        selectedColors.append(colorInfo)
                        if selectedColors.count >= count {
                            break
                        }
                    }
                }
                
                // 선택된 색상 수가 부족하면 거리 임계값을 낮춤
                distanceThreshold -= 5.0
            }
            
            // 여전히 선택된 색상 수가 부족하면 빈도가 높은 순서대로 추가
            if selectedColors.count < count {
                for colorInfo in filteredColors {
                    if selectedColors.contains(where: { $0.color == colorInfo.color }) {
                        continue
                    }
                    selectedColors.append(colorInfo)
                    if selectedColors.count >= count {
                        break
                    }
                }
            }
            
            return selectedColors
        }
        
        /// 두 색상 간의 Lab 색상 공간에서의 거리 계산
        private func colorDistanceLab(_ color1: Color, _ color2: Color) -> Double {
            // Color를 UIColor로 변환
            let uiColor1 = UIColor(color1)
            let uiColor2 = UIColor(color2)
            
            // UIColor를 Lab 값으로 변환
            let lab1 = uiColor1.toLab()
            let lab2 = uiColor2.toLab()
            
            // 유클리드 거리 계산
            let deltaL = lab1.L - lab2.L
            let deltaA = lab1.a - lab2.a
            let deltaB = lab1.b - lab2.b
            
            return sqrt(deltaL * deltaL + deltaA * deltaA + deltaB * deltaB)
        }
    }
}
