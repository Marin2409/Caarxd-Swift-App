//
//  FirebaseUserService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import FirebaseFirestore

class FirebaseUserService {
    static let shared = FirebaseUserService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Create User Profile
    func createUserProfile(userID: String, email: String, firstName: String, lastName: String, phone: String) async throws {
        let userData: [String: Any] = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]

        try await db.collection("users").document(userID).setData(userData)
    }

    // MARK: - Get User Profile
    func getUserProfile(userID: String) async throws -> [String: Any]? {
        let document = try await db.collection("users").document(userID).getDocument()
        return document.data()
    }

    // MARK: - Update User Profile
    func updateUserProfile(userID: String, data: [String: Any]) async throws {
        var updateData = data
        updateData["updatedAt"] = FieldValue.serverTimestamp()

        try await db.collection("users").document(userID).updateData(updateData)
    }

    // MARK: - Delete User Profile
    func deleteUserProfile(userID: String) async throws {
        // Delete all user's business cards
        let cardsSnapshot = try await db.collection("users").document(userID)
            .collection("businessCards").getDocuments()

        for document in cardsSnapshot.documents {
            try await document.reference.delete()
        }

        // Delete user profile
        try await db.collection("users").document(userID).delete()
    }
}
