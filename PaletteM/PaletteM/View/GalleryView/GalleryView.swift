//
//  GalleryView.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import SwiftUI

struct GalleryView: View {
    
    @EnvironmentObject var viewModel: GalleryViewModel
    @EnvironmentObject var colorExtractor: ColorExtractorViewModel
    @State private var path: [NavigationDestination] = []
    @Binding var isShowSelectGallery: Bool
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                
                SelectedPhotoView(viewModel: viewModel, size: UIScreen.main.bounds.width)
                
                Rectangle()
                    .fill(.background)
                    .frame(maxHeight: 12)
                    .padding(.vertical, 4)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(viewModel.photos) { photo in
                            PhotoThumbnail(photo: photo, size: UIScreen.main.bounds.width / 3 - 1)
                                .overlay(
                                    Color.softBeige.opacity(viewModel.selectedPhoto?.id == photo.id ? 0.3 : 0)
                                )
                                .contentShape(.rect)
                                .onTapGesture {
                                    viewModel.selectPhoto(photo)
                                }
                        }
                    }
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch  destination {
                case .resultView:
                    ResultView(path: $path, isShowSelectGallery: $isShowSelectGallery)
                }
                
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isShowSelectGallery = false 
                    }, label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.softBeige)
                    })
                }
                
                ToolbarItem(placement:.topBarTrailing) {
                    
                    Button(action: {
                        if let selectedImage = viewModel.selectedImage{
                            colorExtractor.selectImage(selectedImage)
                        }
                        path.append(.resultView)
                        
                    }, label: {
                        Text("선택")
                            .fontWeight(.semibold)
                    })
                    .disabled(viewModel.selectedPhoto == nil)
                 
                }
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
        .onAppear {
            if viewModel.photos.isEmpty {
                viewModel.fetchPhotos()
            }
        }
        .onDisappear{
            viewModel.clear()  
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(isShowSelectGallery: .constant(true))
    }
    
    static func mockGalleryViewModel() -> GalleryViewModel {
        let viewModel = GalleryViewModel()
        viewModel.photos = (1...16).map { _ in
            Photo(image: UIImage(named: "sample_person2")!)
        }
        viewModel.selectedPhoto = viewModel.photos.first
        return viewModel
    }
}
