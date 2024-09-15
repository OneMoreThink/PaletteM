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
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                StackView()
                    
            }
            .navigationTitle("PaletteM")
        }
        
    }
    
}

#Preview {
    
    let container = PreviewContainer(ImageData.self)
    
    let sampleImageData1 = UIImage(named: "sample_person1")?.pngData() ?? Data()
    let sampleImage1 = ImageData(imageData: sampleImageData1, colorInfos: [
        ColorInfo(color: .red, percentage: 0.3),
        ColorInfo(color: .green, percentage: 0.5),
        ColorInfo(color: .black, percentage: 0.2)
    ])
    let sampleImageData2 = UIImage(named: "sample_person2")?.pngData() ?? Data()
    let sampleImage2 = ImageData(imageData: sampleImageData2, colorInfos: [
        ColorInfo(color: .red, percentage: 0.3),
        ColorInfo(color: .blue, percentage: 0.5),
        ColorInfo(color: .yellow, percentage: 0.2)
    ])
    let sampleImageData3 = UIImage(named: "sample_person3")?.pngData() ?? Data()
    let sampleImage3 = ImageData(imageData: sampleImageData3, colorInfos: [
        ColorInfo(color: .orange, percentage: 0.3),
        ColorInfo(color: .cyan, percentage: 0.5),
        ColorInfo(color: .gray, percentage: 0.2)
    ])
    
    container.addExamples([sampleImage1,sampleImage2,sampleImage3])
    return  ContentView()
        .modelContainer(container.container)
}
