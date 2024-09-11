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
    /// 잘못된 flow에 대한 교정 메시지
    
    /// 이미지 선택 메서드
    //MARK: 이미지 선택 로직과 선택된 이미지를 실제로 분석처리를 요청하는 로직과 분리 필요 
    func selectImage(_ image: UIImage) {
        selectedImage = image
        extractColors(from: image)
    }
    
    /// 선택 이미지 초기화 메서드
    func resetImage(){
        selectedImage = nil
        extractedColors = []
        isProcessing = false
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
