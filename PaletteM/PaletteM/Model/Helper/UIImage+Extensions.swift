//
//  UIImage+Extensions.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI

extension UIImage {
    func pixelData() -> [UInt8]? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = Int(cgImage.width)
        let height = Int(cgImage.height)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = height * bytesPerRow
        
        var pixelData = [UInt8](repeating: 0, count: totalBytes)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue // RGBA 순서
        
        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        return pixelData
    }
}
