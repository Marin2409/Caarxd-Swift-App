//
//  ContentView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [BusinessCard.self, Contact.self, AnalyticsEvent.self, WorkCard.self])
}
