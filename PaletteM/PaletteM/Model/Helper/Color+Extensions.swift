//
//  Color+Extensions.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

extension Color {
    /// Color를 UIColor로 변환
    init(_ uiColor: UIColor) {
        self.init(uiColor)
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(opacity, forKey: .opacity)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        let opacity = try container.decode(CGFloat.self, forKey: .opacity)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
    }
    
    /// Color를 HEX 문자열로 변환
    func toHexString() -> String {
        let uiColor = UIColor(self)
        return uiColor.toHexString()
    }
    
    /// Color를 RGB 문자열로 변환
    func toRGBString() -> String {
        let uiColor = UIColor(self)
        return uiColor.toRGBString()
    }
}
