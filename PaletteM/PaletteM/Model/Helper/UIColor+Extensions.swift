//
//  UIColor.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

extension UIColor {
    /// UIColor를 Lab 색상 공간으로 변환
    func toLab() -> (L: Double, a: Double, b: Double) {
        // sRGB에서 XYZ로 변환
        var r = Double(self.cgColor.components?[0] ?? 0)
        var g = Double(self.cgColor.components?[1] ?? 0)
        var blue = Double(self.cgColor.components?[2] ?? 0)
        
        // 선형화
        r = r > 0.04045 ? pow((r + 0.055) / 1.055, 2.4) : r / 12.92
        g = g > 0.04045 ? pow((g + 0.055) / 1.055, 2.4) : g / 12.92
        blue = blue > 0.04045 ? pow((blue + 0.055) / 1.055, 2.4) : blue / 12.92
        
        // XYZ 변환
        let X = (r * 0.4124 + g * 0.3576 + blue * 0.1805) / 0.95047
        let Y = (r * 0.2126 + g * 0.7152 + blue * 0.0722) / 1.00000
        let Z = (r * 0.0193 + g * 0.1192 + blue * 0.9505) / 1.08883
        
        // XYZ에서 Lab로 변환
        func f(_ t: Double) -> Double {
            return t > 0.008856 ? pow(t, 1.0/3.0) : (7.787 * t) + (16.0 / 116.0)
        }
        
        let fx = f(X)
        let fy = f(Y)
        let fz = f(Z)
        
        let labL = (116 * fy) - 16
        let labA = 500 * (fx - fy)
        let labB = 200 * (fy - fz)
        
        return (L: labL, a: labA, b: labB)
    }
    
    /// UIColor의 채도(Saturation)를 반환합니다.
    var saturation: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return saturation
        }
        
        return 0 // 기본값
    }
    
    /// 양자화된 색상 키를 생성합니다.
    func quantizedColorKey(bitsPerChannel: UInt8) -> UInt32 {
        let maxChannelValue = CGFloat((1 << bitsPerChannel) - 1)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let quantizedR = UInt8(red * maxChannelValue)
        let quantizedG = UInt8(green * maxChannelValue)
        let quantizedB = UInt8(blue * maxChannelValue)
        let quantizedA = UInt8(alpha * maxChannelValue)
        
        let colorKey = UInt32(quantizedR) << 24 | UInt32(quantizedG) << 16 | UInt32(quantizedB) << 8 | UInt32(quantizedA)
        
        return colorKey
    }
}
