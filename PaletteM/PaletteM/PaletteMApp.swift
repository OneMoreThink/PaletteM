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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ImageData.self)
    }
}
