//
//  ImageLoadingService.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import PhotosUI

class ImageLoadingService {
    static let shared = ImageLoadingService()
    private let imageManager = PHImageManager.default()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = "\(asset.localIdentifier)_\(Int(size.width))x\(Int(size.height))"
        
        if let cachedImage = cache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { [weak self] image, _ in
            if let image = image {
                self?.cache.setObject(image, forKey: cacheKey as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
