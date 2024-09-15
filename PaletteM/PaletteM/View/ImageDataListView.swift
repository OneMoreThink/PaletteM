//
//  ImageDataListView.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

import SwiftUI
import SwiftData

struct ImageDataListView: View {
    @Query private var images: [ImageData]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        
        List(images) { imageData in
            if let uiImage = UIImage(data: imageData.imageData) {
                VStack{
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                    HStack{
                        ForEach(imageData.colorInfos){
                            color in
                            Color(color.color)
                        }
                    }
                }
            } else {
                Text("이미지를 불러올 수 없습니다.")
            }
        }
        Button("이미지 저장") {
            saveImage()
        }
    }
    
    func saveImage() {
        guard let image = UIImage(named: "sample_dog1"),
              let imageData = image.pngData() else {
            print("이미지를 불러올 수 없습니다.")
            return
        }
        
        let colorInfos = [
            ColorInfo(color: .red, percentage: 0.3),
            ColorInfo(color: .blue, percentage: 0.5),
            ColorInfo(color: .green, percentage: 0.2)
        ]
        
        let newImageData = ImageData(imageData: imageData, colorInfos: colorInfos)
        context.insert(newImageData)
        
        do {
            try context.save()
            print("이미지가 성공적으로 저장되었습니다.")
        } catch {
            print("이미지 저장 중 오류 발생: \(error)")
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
    return ImageDataListView()
        .modelContainer(container.container)
}
