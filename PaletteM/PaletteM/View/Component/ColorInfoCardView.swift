//
//  ColorInfoCardView.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

struct ColorInfoCardView: View {
    
    let colorInfo: ColorInfo
    
    
    var body: some View {
        HStack {
            // 색상을 나타내는 동그라미
            Circle()
                .fill(colorInfo.color)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 2) {
                // HEX 값
                Text("\(colorInfo.color.toHexString())")
                    
                // RGB 값
                Text("\(colorInfo.color.toRGBString())")
            }
            .foregroundStyle(.black)
            .font(.subheadline)
            .fontWeight(.semibold)
            
        }
    }
}

#Preview {
    ColorInfoCardView(colorInfo: ColorInfo(color: .cyan, percentage: 0.24))
}
