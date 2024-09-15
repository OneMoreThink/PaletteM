//
//  PhotoFrameView.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

struct PhotoFrameView: View {
    let image: UIImage
    let colors: [ColorInfo]
    let minColorWidth: CGFloat = 100 // 각 색상의 최소 넓이
    
    var body: some View {
        GeometryReader { geometry in
            let frameSize = geometry.size
            let imageSize = image.size
            
            // 이미지 크기 계산 (프레임의 상단에 가로 폭에 맞춰서 표시)
            let imageHeight = frameSize.width / (imageSize.width / imageSize.height)
            let remainingHeight = frameSize.height - imageHeight
            
            // 색상 셀 영역의 높이 설정 (고정된 크기)
            let colorCellsHeight = remainingHeight
            
            // 퍼센티지 합계 계산 및 정규화
            let totalPercentage = colors.reduce(0) { $0 + $1.percentage }
            let normalizedColors = colors.map { colorInfo in
                ColorInfo(color: colorInfo.color, percentage: colorInfo.percentage / totalPercentage)
            }
            
            let totalAvailableWidth = frameSize.width
            let availableWidthWithoutMinimums = totalAvailableWidth - CGFloat(colors.count) * minColorWidth
            
            // 최소 넓이를 고려하여 각 색상의 최종 넓이 계산
            let finalWidths = normalizedColors.map { colorInfo -> CGFloat in
                let proportionalWidth = totalAvailableWidth * CGFloat(colorInfo.percentage)
                return max(proportionalWidth, minColorWidth)
            }
            
            let totalFinalWidth = finalWidths.reduce(0, +)
            
            VStack(spacing: 0) {
                // 이미지 표시
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: frameSize.width, height: imageHeight)
                    .clipped()
                
                // 색상 셀 배치 (하나의 행)
                HStack(spacing: 0) {
                    ForEach(Array(zip(normalizedColors, finalWidths)), id: \.0.id) { colorInfo, width in
                        Color(colorInfo.color)
                            .frame(width: width * totalAvailableWidth / totalFinalWidth, height: colorCellsHeight)
                    }
                }
                .frame(width: frameSize.width, height: colorCellsHeight)
            }
            .frame(width: frameSize.width, height: frameSize.height)
        }
    }
}



struct PhotoFrameView_Previews: PreviewProvider {
    static var previews: some View {
        // 예시 이미지를 로드합니다.
        let sampleImage = UIImage(named: "sample_dog1")!

        // 예시 색상 정보를 만듭니다.
        let extractedColors: [ColorInfo] = [
            ColorInfo(color: .red, percentage: 40),
            ColorInfo(color: .green, percentage: 30),
            ColorInfo(color: .blue, percentage: 20),
        ]

        return PhotoFrameView(image: sampleImage, colors: extractedColors)
            
    }
    
}
