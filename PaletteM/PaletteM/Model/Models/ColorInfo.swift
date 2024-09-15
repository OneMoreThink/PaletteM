//
//  ColorInfo.swift
//  PaletteM
//
//  Created by 이종선 on 9/11/24.
//

import SwiftUI

// MARK: - Model
struct ColorInfo: Identifiable {
    let id = UUID()
    let color: Color
    let percentage: Double
}
