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
    // 크림색 오프화이트
       static let creamyWhite = Color(red: 253/255, green: 252/255, blue: 245/255)
       
       // 따뜻한 오프화이트
       static let warmOffWhite = Color(red: 255/255, green: 253/255, blue: 248/255)
       
       // 차가운 오프화이트
       static let coolOffWhite = Color(red: 248/255, green: 250/255, blue: 252/255)
       
       // 매우 연한 베이지
       static let softBeige = Color(red: 245/255, green: 245/255, blue: 237/255)
}
