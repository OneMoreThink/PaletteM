//
//  FlipCard.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

struct FlipCard: View {
    @State private var isFlipped = false
    
    let image: UIImage
    let colors: [ColorInfo]
    
    var body: some View {
        ZStack{
            ColorInfoView(colors: colors)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -90),
                                  axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .animation(isFlipped ? .linear.delay(0.35) : .linear, value: isFlipped)
            
            PhotoFrameView(image: image, colors: colors)
                .rotation3DEffect(.degrees(isFlipped ? 90 : 0),
                                  axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .animation(isFlipped ? .linear : .linear.delay(0.35), value: isFlipped)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 5, y: 5)
        .shadow(color: .gray.opacity(0.15), radius: 5, x: -2, y: -3)
        .shadow(color: .white, radius: 1)
        .frame(maxWidth: 320)
        .frame(maxHeight: 550)
        .padding(.vertical)
        .onTapGesture {
            withAnimation(.easeInOut){
                isFlipped.toggle()
            }
        }
    }
}


struct FlipCard_Previews: PreviewProvider {
    static var previews: some View {
        // 예시 이미지를 로드합니다.
        let sampleImage = UIImage(named: "sample_dog1")!

        // 예시 색상 정보를 만듭니다.
        let extractedColors: [ColorInfo] = [
            ColorInfo(color: .red, percentage: 40),
            ColorInfo(color: .green, percentage: 30),
            ColorInfo(color: .blue, percentage: 20),
        ]

        return FlipCard(image: sampleImage, colors: extractedColors)
            
    }
    
}
