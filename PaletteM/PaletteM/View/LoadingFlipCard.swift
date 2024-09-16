//
//  LoadingFlipCard.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import SwiftUI

// MARK: - 회전하는 카드 애니메이션 뷰
struct RotatingCardView: View {
    @State private var rotationAngle: Double = 0
    let image: UIImage
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.softBeige) // 카드 색상
  
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .cornerRadius(20) // 이미지도 카드 모서리에 맞게 둥글게
        }
        .frame(width: 210, height: 390)
        .frame(maxWidth: 320)
        .frame(maxHeight: 550)
        .rotation3DEffect(
            .degrees(rotationAngle), // 각도에 따라 회전
            axis: (x: 0, y: 1, z: 0) // Y축을 기준으로 회전
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotationAngle = 360 // 360도 회전
            }
        }
        
    }
}
