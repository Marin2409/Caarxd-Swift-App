//
//  AuthState.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

@Observable
class AuthState {
    var isAuthenticated: Bool = false
    var currentUserEmail: String?
    var currentUserID: String?
    var hasCompletedOnboarding: Bool = false
    var hasSeenWelcomeSlides: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?

    static let shared = AuthState()

    private init() {
        loadAuthState()
        setupAuthStateListener()
    }

    // MARK: - Firebase Auth State Listener
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
                self?.currentUserEmail = user?.email
                self?.currentUserID = user?.uid
                self?.saveAuthState()
            }
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await FirebaseAuthService.shared.login(email: email, password: password)

            isAuthenticated = true
            currentUserEmail = user.email
            currentUserID = user.uid
            hasCompletedOnboarding = true // Existing users skip card onboarding
            saveAuthState()

            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, firstName: String, lastName: String, phone: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await FirebaseAuthService.shared.signUp(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                phone: phone
            )

            isAuthenticated = true
            currentUserEmail = user.email
            currentUserID = user.uid
            hasCompletedOnboarding = false // New users see card onboarding
            saveAuthState()

            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Logout
    func logout() {
        do {
            try FirebaseAuthService.shared.logout()

            isAuthenticated = false
            currentUserEmail = nil
            currentUserID = nil
            hasCompletedOnboarding = false
            saveAuthState()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Complete Onboarding
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveAuthState()
    }

    // MARK: - Mark Welcome Slides as Seen
    func markWelcomeSlidesAsSeen() {
        hasSeenWelcomeSlides = true
        saveAuthState()
    }

    // MARK: - Password Reset
    func resetPassword(email: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            try await FirebaseAuthService.shared.resetPassword(email: email)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Delete Account
    func deleteAccount() async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            try await FirebaseAuthService.shared.deleteAccount()

            isAuthenticated = false
            currentUserEmail = nil
            currentUserID = nil
            hasCompletedOnboarding = false
            saveAuthState()

            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Persistence
    private func saveAuthState() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(hasSeenWelcomeSlides, forKey: "hasSeenWelcomeSlides")
    }

    private func loadAuthState() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        hasSeenWelcomeSlides = UserDefaults.standard.bool(forKey: "hasSeenWelcomeSlides")

        // Check Firebase auth state
        if let user = Auth.auth().currentUser {
            isAuthenticated = true
            currentUserEmail = user.email
            currentUserID = user.uid
        }
    }
}
