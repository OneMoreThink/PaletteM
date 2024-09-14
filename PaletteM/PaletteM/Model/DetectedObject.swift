//
//  RecognizedObject.swift
//  PaletteM
//
//  Created by 이종선 on 9/11/24.
//

import Foundation

struct DetectedObject: Identifiable {
    let id: String = UUID().uuidString
    let label: String
    let boundingBox: CGRect
}
