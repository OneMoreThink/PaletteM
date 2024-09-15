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
