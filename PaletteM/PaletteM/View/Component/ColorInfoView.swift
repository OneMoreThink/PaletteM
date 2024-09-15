//
//  ColorInfoView.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

struct ColorInfoView: View {
    
    let colors: [ColorInfo]
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            Rectangle()
                .fill(.white)
                .overlay{
                    VStack{
                        ForEach(colors) { color in
                            ColorInfoCardView(colorInfo: color)
                                .padding(.vertical)
                        }
                    }
                }
        }
        
    }
}

#Preview {
    ColorInfoView(colors: [ColorInfo(color: .green, percentage: 0.23), ColorInfo(color: .orange, percentage: 0.43), ColorInfo(color: .red, percentage: 0.12)])
}
