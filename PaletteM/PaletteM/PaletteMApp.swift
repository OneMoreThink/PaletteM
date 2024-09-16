//
//  PaletteMApp.swift
//  PaletteM
//
//  Created by 이종선 on 9/11/24.
//

import SwiftUI
import SwiftData

@main
struct PaletteMApp: App {
    
    @StateObject var galleryVm = GalleryViewModel()
    @StateObject var colorExtractor = ColorExtractorViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(galleryVm)
        .environmentObject(colorExtractor)
        .modelContainer(for: ImageData.self)
    }
}
