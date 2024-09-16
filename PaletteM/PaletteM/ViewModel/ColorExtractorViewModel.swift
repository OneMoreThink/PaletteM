//
//  ColorExtractorViewModel.swift
//  PaletteM
//
//  Created by 이종선 on 9/11/24.
//

import SwiftUI

// MARK: - ViewModel
class ColorExtractorViewModel: ObservableObject {
    /// 사용자가 색상을 뽑고자하는 이미지
    @Published var selectedImage: UIImage?
    /// 색상 추출 프로세스를 통해 나온 결과 색상값들
    @Published var extractedColors: [ColorInfo] = []
    /// 색상 추출 프로세스 진행중 flag
    @Published var isProcessing = false
    /// 감지된 객체들
    @Published var detectedObjects: [DetectedObject] = []
    /// 객체 감지 에러
    @Published var detectionError: ObjectDetectionErorr?
    /// 객체가 감지된 이미지를 저장 ( for bounding box image)
    @Published var imageWithDetectedObjects: UIImage?
    /// 제일 많이 등장한 색 중에 서로 제일 다른색들 뽑기
    @Published var distinctColors: [ColorInfo] = []
    
    private let objectDetectionManager = ObjectDetectionManager.shared
    private let colorExtractionManager = ColorExtractionManager.shared
    
    
    /// 이미지 선택 메서드
    func selectImage(_ image: UIImage) {
        selectedImage = image
        detectObjects(in: image)
    }
    
    /// 선택 이미지 초기화 메서드
    func resetImage(){
        selectedImage = nil
        extractedColors = []
        detectedObjects = []
        detectionError = nil
        imageWithDetectedObjects = nil
        distinctColors = []
        isProcessing = false
        
    }
    
    private func detectObjects(in image: UIImage){
        isProcessing = true
        
        objectDetectionManager.detectObject(in: image) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let objects):
                    self?.detectedObjects = objects
                    // MARK: 객체가 감지가 완료된 시점이후 박스 표시
                    //self?.drawDetectedObjectsOnImage()
                    
                    // 객체가 감지가 완료된 이후에 색생 추출을 수행
                    self?.extractColors(from: image)
                    
                case .failure(let error):
                    self?.detectedObjects = []
                    self?.detectionError = error
                    
                    // 객체가 감지에 실패해도 색상 추출을 시도
                    self?.extractColors(from: image)
                }
            }
        }
    }
    
    /// 색상 추출 프로세스 구현
    private func extractColors(from image: UIImage) {
        
        // 레이블별 가중치를 정의합니다.
        let labelWeights: [String: Double] = [
            // 필요한 레이블과 가중치를 추가
            "person": 1.5,
        ]
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let extractedColor = self.colorExtractionManager.extractColors(from: image, detectedObjects: self.detectedObjects, labelWeights: labelWeights)
            let distinctedColor = self.colorExtractionManager.selectDistinctColors(from: extractedColor)
            DispatchQueue.main.async {
                self.extractedColors = extractedColor
                // 최대 구분색 추가
                self.distinctColors = distinctedColor
                self.isProcessing = false
            }
        }
    }
    
    private func drawDetectedObjectsOnImage() {
        guard let image = selectedImage else {
            print("No image selected")
            return
        }
        
        print("Drawing objects on image of size: \(image.size.width) x \(image.size.height)")
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let drawnImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            let ctx = context.cgContext
            
            for object in detectedObjects {
                print("Adjusted bounding box: \(object.boundingBox)")
                
                ctx.setStrokeColor(UIColor.red.cgColor)
                ctx.setLineWidth(2)
                ctx.stroke(object.boundingBox)
                
                // 레이블 텍스트 그리기
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor: UIColor.white
                ]
                let text = object.label as NSString
                let textSize = text.size(withAttributes: attributes)
                let textRect = CGRect(
                    x: object.boundingBox.minX,
                    y: max(0, object.boundingBox.minY - textSize.height),
                    width: min(textSize.width + 4, image.size.width - object.boundingBox.minX),
                    height: min(textSize.height, object.boundingBox.minY)
                )
                
                ctx.setFillColor(UIColor.red.cgColor)
                ctx.fill(textRect)
                
                text.draw(in: textRect, withAttributes: attributes)
            }
        }
        
        DispatchQueue.main.async {
            self.imageWithDetectedObjects = drawnImage
        }
    }
}
