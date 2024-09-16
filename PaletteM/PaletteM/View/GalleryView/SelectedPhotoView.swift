//
//  SelectedPhotoView.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import SwiftUI

struct SelectedPhotoView: View {
    @ObservedObject var viewModel: GalleryViewModel
    let size : CGFloat
    
    var body: some View {
        Group {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if viewModel.selectedPhoto != nil {
                ProgressView()
            } else {
                Text("선택된 사진이 없습니다.")
            }
        }
        .frame(width: size, height: size)
        .clipped()
    }
}
