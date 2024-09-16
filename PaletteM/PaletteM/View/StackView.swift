//
//  StackView.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI
import SwiftData

struct StackView: View {
    
    // View Properties
    @State private var isRotationEnabled: Bool = true
    @State private var showsIndicator: Bool = false
    @Query(sort: \ImageData.createdAt, order: .reverse) private var items: [ImageData]
    
    var body: some View {
        NavigationStack{
            VStack {
                GeometryReader {
                    let size = $0.size
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 0){
                            ForEach(items) { item in
                                if let image = UIImage(data: item.imageData) {
                                    FlipCard(image: image, colors: item.colorInfos)
                                        .frame(width: size.width)
                                        .visualEffect { content, geometryProxy in
                                            content
                                                .scaleEffect(scale(geometryProxy,scale: 0.1), anchor: .trailing)
                                                .rotationEffect(rotation(geometryProxy, rotation: 6))
                                                .offset(x: minX(geometryProxy))
                                                .offset(x: excessMinX(geometryProxy,offset: 10  ))
                                        }
                                        .zIndex(items.zIndex(item))
                                }
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(showsIndicator ? .visible : .hidden)
                }
            }
        }
    }
    
    /// Stacked Cards Animation
    func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    ///
    func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        // converting into progress
        let progress = (maxX / width) - 1.0
        let cappedProgress = min(progress, limit)
        
        return cappedProgress
    }
    
    func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy, limit: 3)
        return 1 - (progress * scale)
    }
    
    func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy)
        return 1 - (progress * offset)
    }
    
    func rotation(_ proxy: GeometryProxy, rotation: CGFloat = 5) -> Angle {
        let progress = progress(proxy)
        return .init(degrees: progress * rotation)
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
    return StackView()
        .modelContainer(container.container)
    
}
