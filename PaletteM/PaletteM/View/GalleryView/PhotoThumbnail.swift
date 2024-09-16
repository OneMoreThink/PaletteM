//
//  PhotoThumbnail.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import PhotosUI
import SwiftUI

struct PhotoThumbnail: View {
    let photo: Photo
    @State private var image: UIImage?
    let size: CGFloat
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
            }
        }
        .frame(width: size, height: size)
        .clipped()
        .onAppear(perform: loadImage)
        
    }
    
    private func loadImage() {
        if let asset = photo.asset {
            ImageLoadingService.shared.loadImage(for: asset, size: CGSize(width: size, height: size)) { loadedImage in
                self.image = loadedImage
            }
        }
    }
}
