//
//  FirebaseAuthService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import FirebaseAuth
import FirebaseAnalytics

@Observable
class FirebaseAuthService {
    static let shared = FirebaseAuthService()

    var currentUser: FirebaseAuth.User?
    var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }

    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    private init() {
        // Listen for auth state changes
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }

    deinit {
        // Remove listener when service is deallocated
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, firstName: String, lastName: String, phone: String) async throws -> FirebaseAuth.User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)

        // Update display name
        let changeRequest = authResult.user.createProfileChangeRequest()
        changeRequest.displayName = "\(firstName) \(lastName)"
        try await changeRequest.commitChanges()

        // Log analytics event
        Analytics.logEvent("sign_up", parameters: [
            "method": "email",
            "user_id": authResult.user.uid
        ])

        // Create user profile in Firestore
        try await FirebaseUserService.shared.createUserProfile(
            userID: authResult.user.uid,
            email: email,
            firstName: firstName,
            lastName: lastName,
            phone: phone
        )

        return authResult.user
    }

    // MARK: - Login
    func login(email: String, password: String) async throws -> FirebaseAuth.User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)

        // Log analytics event
        Analytics.logEvent(AnalyticsEventLogin, parameters: [
            "method": "email",
            "user_id": authResult.user.uid
        ])

        return authResult.user
    }

    // MARK: - Logout
    func logout() throws {
        try Auth.auth().signOut()

        // Log analytics event
        Analytics.logEvent("logout", parameters: [:])
    }

    // MARK: - Password Reset
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)

        // Log analytics event
        Analytics.logEvent("password_reset_request", parameters: [
            "email": email
        ])
    }

    // MARK: - Delete Account
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "FirebaseAuthService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }

        // Delete user profile from Firestore
        if let userID = currentUserID {
            try await FirebaseUserService.shared.deleteUserProfile(userID: userID)
        }

        // Delete Firebase Auth account
        try await user.delete()

        // Log analytics event
        Analytics.logEvent("account_deleted", parameters: [:])
    }
}
