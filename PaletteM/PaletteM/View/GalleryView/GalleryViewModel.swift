//
//  GalleryViewModel.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import PhotosUI

class GalleryViewModel: ObservableObject {
    
    @Published var photos: [Photo] = []
    @Published var selectedPhoto: Photo?
    @Published var selectedImage: UIImage?
    private let imageLoadingService = ImageLoadingService.shared
    
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        photos = assets.objects(at: IndexSet(0..<assets.count)).map { Photo(asset: $0) }
        
        if let firstPhoto = photos.first {
            selectedPhoto = firstPhoto
            loadSelectedImage()
        }
    }
    
    func selectPhoto(_ photo: Photo) {
        self.selectedPhoto = photo
        loadSelectedImage()
    }
    
    private func loadSelectedImage() {
        guard let photo = selectedPhoto else {
            selectedImage = nil
            return
        }
        if let asset = photo.asset{
            imageLoadingService.loadImage(for: asset, size: PHImageManagerMaximumSize) { [weak self] image in
                DispatchQueue.main.async {
                    self?.selectedImage = image
                }
            }
        }
    }
}
