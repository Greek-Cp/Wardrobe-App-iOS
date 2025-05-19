//
//  WardrobeApp1App.swift
//  WardrobeApp1
//
//  Created by Mac on 08/05/25.
//

import SwiftUI
import SwiftData

@main
struct WardrobeApp: App {
    let container: ModelContainer
    
    init() {
        let customColor = UIColor(red: 146/255, green: 198/255, blue: 164/255, alpha: 1.0)
            UINavigationBar.appearance().tintColor = customColor
        do {
            let schema = Schema([
                WardrobeItem.self
            ])
            
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
            
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
