//
//  ContentView.swift
//  PaletteM
//
//  Created by 이종선 on 9/11/24.
//

import SwiftUI

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = ColorExtractorViewModel()
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            if let selectedImage = viewModel.selectedImage {
                PhotoFrameView(image: selectedImage, colors: viewModel.distinctColors)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(maxHeight: 800)
                    .padding()
                
            } else if viewModel.isProcessing {
                ProgressView("Processing image...")
            } else {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.gray.opacity(0.2))
                    .frame(maxHeight: 700)
                    .padding()
                    .overlay{
                        Text("No Selected Image")
                            .font(.title)
                    }
            }
            
            Button("Select Sample Image") {
                // 여기서 샘플 이미지를 선택합니다.
                // 실제 앱에서는 PHPickerViewController를 사용할 수 있습니다.
                // 또는 camera를 이용해 사진을 찍는 로직
                if let sampleImage = UIImage(named: "sample_person2") {
                    viewModel.selectImage(sampleImage)
                }
            }
            .padding()
            
            Button("Reset Image") {
                viewModel.resetImage()
            }
            .disabled(viewModel.selectedImage == nil)
        }
    }
}

#Preview {
    ContentView()
}
