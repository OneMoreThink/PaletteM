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
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    
            } else {
                Text("선택한 이미지가 없습니다.")
                    .frame(height: 200)
            }
            
            if let detectedImage = viewModel.imageWithDetectedObjects {
                Image(uiImage: detectedImage)
                    .resizable()
                    .scaledToFit()
                    
                    
                
            } else if viewModel.isProcessing {
                ProgressView("Processing image...")
            } else {
                Text("No image selected")
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
            
            if viewModel.isProcessing {
                ProgressView()
            } else {
                List(viewModel.extractedColors) { colorInfo in
                    HStack {
                        Rectangle()
                            .fill(colorInfo.color)
                            .frame(width: 50, height: 50)
                        Text("\(colorInfo.percentage, specifier: "%.1f")%")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
