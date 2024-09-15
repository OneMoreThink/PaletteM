//
//  PreviewContainer.swift
//  PaletteM
//
//  Created by 이종선 on 9/15/24.
//

import SwiftUI
import SwiftData

struct PreviewContainer {
    let container: ModelContainer
    
    init(_ types: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(types)
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create preview container: \(error.localizedDescription)")
        }
    }
    
    func addExamples(_ examples: [any PersistentModel]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}
