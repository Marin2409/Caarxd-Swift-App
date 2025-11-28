//
//  AuthState.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftUI

@Observable
class AuthState {
    var isAuthenticated: Bool = false
    var currentUserEmail: String?
    var hasCompletedOnboarding: Bool = false
    var hasSeenWelcomeSlides: Bool = false

    static let shared = AuthState()

    private init() {
        loadAuthState()
    }

    func login(email: String, password: String) -> Bool {
        // For now, simple local validation
        // Later: Firebase authentication
        if let user = UserDefaults.standard.string(forKey: "user_\(email)_password"),
           user == password {
            isAuthenticated = true
            currentUserEmail = email
            hasCompletedOnboarding = true // Existing users skip card onboarding
            saveAuthState()
            return true
        }
        return false
    }

    func signUp(email: String, password: String, firstName: String, lastName: String, phone: String) -> Bool {
        // Check if user already exists
        if UserDefaults.standard.string(forKey: "user_\(email)_password") != nil {
            return false // User already exists
        }

        // Save user credentials (Later: Firebase)
        UserDefaults.standard.set(password, forKey: "user_\(email)_password")
        UserDefaults.standard.set(firstName, forKey: "user_\(email)_firstName")
        UserDefaults.standard.set(lastName, forKey: "user_\(email)_lastName")
        UserDefaults.standard.set(phone, forKey: "user_\(email)_phone")

        isAuthenticated = true
        currentUserEmail = email
        hasCompletedOnboarding = false
        saveAuthState()
        return true
    }

    func logout() {
        isAuthenticated = false
        currentUserEmail = nil
        hasCompletedOnboarding = false
        saveAuthState()
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveAuthState()
    }

    func markWelcomeSlidesAsSeen() {
        hasSeenWelcomeSlides = true
        saveAuthState()
    }

    private func saveAuthState() {
        UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        UserDefaults.standard.set(currentUserEmail, forKey: "currentUserEmail")
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(hasSeenWelcomeSlides, forKey: "hasSeenWelcomeSlides")
    }

    private func loadAuthState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail")
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        hasSeenWelcomeSlides = UserDefaults.standard.bool(forKey: "hasSeenWelcomeSlides")
    }
}
