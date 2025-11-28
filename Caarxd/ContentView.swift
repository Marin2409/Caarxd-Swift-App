//
//  ContentView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var authState = AuthState.shared
    @State private var showingCardOnboarding = false

    var body: some View {
        Group {
            if !authState.hasSeenWelcomeSlides {
                // Show onboarding slides
                OnboardingSlidesView()
            } else if !authState.isAuthenticated {
                // Show login/signup (shouldn't happen, but fallback)
                OnboardingSlidesView()
            } else if !authState.hasCompletedOnboarding {
                // Show card creation onboarding
                CardCreationOnboardingView()
            } else {
                // Show main app
                MainTabView()
            }
        }
        .onAppear {
            checkOnboardingStatus()
        }
    }

    private func checkOnboardingStatus() {
        // Check if user just signed up and needs onboarding
        if authState.isAuthenticated && !authState.hasCompletedOnboarding {
            showingCardOnboarding = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [BusinessCard.self, Contact.self, AnalyticsEvent.self, WorkCard.self])
}
