//
//  File.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import SwiftUI
import PhotosUI

struct Photo: Identifiable {
    let id: String
    let asset: PHAsset?
    let image: UIImage?
    
    init(asset: PHAsset) {
        self.id = asset.localIdentifier
        self.asset = asset
        self.image = nil
    }
    
    init(image: UIImage) {
        self.id = UUID().uuidString
        self.asset = nil
        self.image = image
    }
}
