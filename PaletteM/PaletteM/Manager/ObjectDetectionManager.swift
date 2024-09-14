//
//  ObjectRecognitionManager.swift
//  PaletteM
//
//  Created by 이종선 on 9/11/24.
//

import Vision
import SwiftUI

enum ObjectDetectionErorr: Error {
    case modelNotAvailable
    case imageNotAvailable
    case detectionFailed(underlying: Error)
    
    var errorDescription: String {
        switch self {
        case .modelNotAvailable:
            "Object detection model is not available"
        case .imageNotAvailable:
            "Input Image is not available"
        case .detectionFailed(let error):
            "Object detection failed\(error.localizedDescription)"
        }
    }
    
}

/// MLModel를 활용해 주어진 사진에 있는 객체를 판별합니다.
class ObjectDetectionManager{
    
    /// 이용하려는 CoreML model을 참조합니다.
    private var model: VNCoreMLModel?
    
    /// singleton 패턴을 활용합니다.
    static let shared = ObjectDetectionManager()
    
    /// private 를 통해 외부에서의 인스턴스 생성을 막습니다.
    /// 매니저 생성시 사용할 CoreML Model을 Loading 합니다.
    private init(){
        setupModel()
    }
    
    /// MLModel을 초기화 load를 시도합니다.
    private func setupModel() {
        
        do {
            let configuration = MLModelConfiguration()
            let miniYolo = try YOLOv3Int8LUT(configuration: configuration)
            self.model = try VNCoreMLModel(for: miniYolo.model)
        } catch {
            print("Failed to load Core ML Model: \(error)")
        }
    }
    
    /// MLModel을 활용해 주어진 사진에서 객체를 인지합니다.
    /*
     작동순서
     1. detectObjects(in:completion:) 메서드가 호출됩니다.
     2. Request가 구성됩니다 (VNCoreMLRequest 생성).
     3. VNImageRequestHandler가 생성되고 perform 메서드가 호출됩니다.
     4. Vision 프레임워크가 백그라운드에서 이미지 처리를 시작합니다.
     5. perform 메서드가 반환되고, detectObjects 메서드의 실행이 완료됩니다.
     6. 이미지 처리가 완료되면, Vision 프레임워크가 1단계에서 정의한 completion handler를 호출합니다.
     7. Completion handler 내에서 결과를 처리하고, 사용자가 제공한 completion closure를 호출합니다.
     */
    func detectObject(in image: UIImage,completion: @escaping ((Result<[DetectedObject], ObjectDetectionErorr>) -> Void)){
        
        /// 이미지 요청을 수행하기 전 image 요청에 필요한 Model이 로드되었는지 확인합니다.
        guard let model = model else {
            completion(.failure(.modelNotAvailable))
            return
        }
        
        /// 이미지 요청을 수행하기전 처리가능한 이미지인지를 확인합니다.
        guard let cgImage = image.cgImage else {
            completion(.failure(.imageNotAvailable))
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            if let error = error {
                completion(.failure(.detectionFailed(underlying: error)))
                return
            }
            
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion(.success([]))
                return
            }
            
            let detectedObjects = results.map{ observation -> DetectedObject in
                // bounding box를 만드는 과정 수정
                //let boundingBox = VNImageRectForNormalizedRect(observation.boundingBox, Int(image.size.width), Int(image.size.height))
                
                let boundingBox = self.convertNormalizedRect(observation.boundingBox, imageSize: image.size)
                
                let topLabel = observation.labels.max(by: {$0.confidence < $1.confidence})?.identifier ?? "Unknown"
                
                return DetectedObject(label: topLabel, boundingBox: boundingBox)
                
            }
            completion(.success(detectedObjects))
        }
        
        let handelr = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handelr.perform([request])
            
        }catch {
            completion(.failure(.detectionFailed(underlying: error)))
        }
        
    }
    
}

extension ObjectDetectionManager {
    
    /// Vision 프레임 워크에서 제공하는 바운딩 박스가 정규화된 좌표계를 사용 (원점이 좌하단에 위치 0.0 ~ 1.0) 사이로 스케일링
    ///  UIKit의 CGRect은 원점이 좌하단에 있음, 단위는 픽셀
    ///  따라서 바운딩 박스를 이미지 위에 정확히 그리기 위해서는 Vision의 정규화된 좌표를 UIKit 좌표계로 변환해야한다.
    ///  정규화된 좌표계를 다시 UIKit 좌표계로 변환하는 메서드
    func convertNormalizedRect(_ normalizedRect: CGRect, imageSize: CGSize) -> CGRect {
        let x = normalizedRect.origin.x * imageSize.width
        let y = (1.0 - normalizedRect.origin.y - normalizedRect.height) * imageSize.height
        let width = normalizedRect.width * imageSize.width
        let height = normalizedRect.height * imageSize.height
        return CGRect(x: x, y: y, width: width, height: height)
    }

}
