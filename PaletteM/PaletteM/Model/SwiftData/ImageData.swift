//
//  ImageData.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftData
import SwiftUI

@Model
class ImageData {
    var id: UUID
    var imageData: Data
    var colorInfos: [ColorInfo]
    
    init(id: UUID = UUID(), imageData: Data, colorInfos: [ColorInfo] = []) {
        self.id = id
        self.imageData = imageData
        self.colorInfos = colorInfos
    }
}

extension [ImageData] {
    func zIndex(_ item: ImageData) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id}){
            return CGFloat(count) - CGFloat(index)
        }
        return .zero
    }
}
