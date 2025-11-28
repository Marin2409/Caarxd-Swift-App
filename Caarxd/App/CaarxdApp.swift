//
//  CaarxdApp.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

@main
struct CaarxdApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(
                for: BusinessCard.self,
                     Contact.self,
                     AnalyticsEvent.self,
                     WorkCard.self
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
