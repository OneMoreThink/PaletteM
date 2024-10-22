//
//  CapturedImageView.swift
//  PaletteM
//
//  Created by 이종선 on 10/22/24.
//

import SwiftUI

// MARK: - Captured Image View
struct CapturedImageView: View {
    let image: UIImage
    let retake: () -> Void
    let confirm: () -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Button(action: retake) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: confirm) {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
}
