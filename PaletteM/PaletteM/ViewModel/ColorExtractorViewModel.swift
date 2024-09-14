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
    
    private let objectDetectionManager = ObjectDetectionManager.shared
    
    
    
    /// 이미지 선택 메서드
    //MARK: 이미지 선택 로직과 선택된 이미지를 실제로 분석처리를 요청하는 로직과 분리 필요 
    func selectImage(_ image: UIImage) {
        selectedImage = image
        detectObjects(in: image)
        extractColors(from: image)
    }
    
    /// 선택 이미지 초기화 메서드
    func resetImage(){
        selectedImage = nil
        extractedColors = []
        detectedObjects = []
        detectionError = nil
        imageWithDetectedObjects = nil
        isProcessing = false
        
    }
    
    private func detectObjects(in image: UIImage){
        isProcessing = true
        
        objectDetectionManager.detectObject(in: image) { [weak self] result in
            
            DispatchQueue.main.async {
                
                self?.isProcessing = false
                
                switch result {
                case .success(let objects):
                    self?.detectedObjects = objects
                    
                    // FIXME: debugging
                    print("Detected \(objects.count) objects")
                    for object in objects {
                        print("Object: \(object.label), Bounding Box: \(object.boundingBox)")
                    }
                    
                    // MARK: 객체가 감지가 완료된 시점이후 박스 표시
                    self?.drawDetectedObjectsOnImage()
                    
                case .failure(let error):
                    self?.detectedObjects = []
                    self?.detectionError = error
                }
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
    
    /// 색상 추출 프로세스 구현
    private func extractColors(from image: UIImage) {
        isProcessing = true
        // 여기에 색상 추출 로직을 구현합니다.
        // 이 예시에서는 더미 데이터를 사용합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.extractedColors = [
                ColorInfo(color: .red, percentage: 30),
                ColorInfo(color: .blue, percentage: 25),
                ColorInfo(color: .green, percentage: 20),
                ColorInfo(color: .yellow, percentage: 15),
                ColorInfo(color: .purple, percentage: 10)
            ]
            self.isProcessing = false
        }
    }
}
