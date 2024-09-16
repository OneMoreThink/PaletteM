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
    
    static let pastelRed = Color(red: 255/255, green: 209/255, blue: 220/255)
    static let pastelGreen = Color(red: 203/255, green: 241/255, blue: 203/255)
    static let pastelBlue = Color(red: 173/255, green: 216/255, blue: 230/255)
    static let pastelYellow = Color(red: 253/255, green: 253/255, blue: 150/255)
    static let softCharcoal = Color(red: 54/255, green: 69/255, blue: 79/255)
    static let softBeige = Color(red: 245/255, green: 245/255, blue: 237/255)
    static let softPink = Color(red: 1.0, green: 0.714, blue: 0.757)
    static let lightPeach = Color(red: 1.0, green: 0.878, blue: 0.675)
    static let mintGreen = Color(red: 0.741, green: 0.918, blue: 0.882)
    static let skyBlue = Color(red: 0.686, green: 0.843, blue: 0.953)
    static let lightBeige = Color(red: 0.96, green: 0.87, blue: 0.70)
    static let darkBeige = Color(red: 0.90, green: 0.75, blue: 0.50)

}
