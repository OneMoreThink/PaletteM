//
//  PreviewView.swift
//  PaletteM
//
//  Created by 이종선 on 10/22/24.
//

import SwiftUI

// MARK: - Preview View
struct PreviewView: View {
    let image: UIImage
    let retake: () -> Void
    let confirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                Spacer()
                HStack {
                    Button(action: retake) {
                        HStack {
                            Image(systemName: "arrow.left")
                        }
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(25)
                    }
                    
                    Spacer()
                    
                    Button(action: confirm) {
                        HStack {
                            Image(systemName: "checkmark")
                        }
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}
