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
            ZStack{
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.714, blue: 0.757),
                        Color(red: 1.0, green: 0.878, blue: 0.675),
                        Color(red: 0.741, green: 0.918, blue: 0.882),
                        Color(red: 0.686, green: 0.843, blue: 0.953)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 8){
                    Text("PaletteM")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.softCharcoal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 24)
                    
                    StackView()
                    
                }
                .padding(.top, 30)
                .ignoresSafeArea()
            }
        }
        .overlay(alignment: .bottom){
            FloatingButton{
                FloatingAction(symbol: "camera", background: .pastelRed) {
                    
                }
                FloatingAction(symbol: "photo", background: .pastelGreen){
                    
                }
                FloatingAction(symbol: "square.and.arrow.up", background: .pastelBlue ) {
                    
                }
            } label: { isExpanded in
                Image(systemName: "plus")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.softBeige)
                    .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                    .scaleEffect(1.02)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.pastelYellow, in: .circle)
                    /// Scaling Effect When Expaned
                    .scaleEffect(isExpanded ? 0.9 : 1)
            }
         

            
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
