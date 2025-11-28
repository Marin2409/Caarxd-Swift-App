//
//  FirebaseCardService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import FirebaseFirestore

class FirebaseCardService {
    static let shared = FirebaseCardService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Create Business Card
    func createBusinessCard(userID: String, card: BusinessCard) async throws -> String {
        let cardData = try cardToDictionary(card)
        let docRef = try await db.collection("users").document(userID)
            .collection("businessCards").addDocument(data: cardData)

        return docRef.documentID
    }

    // MARK: - Update Business Card
    func updateBusinessCard(userID: String, cardID: String, card: BusinessCard) async throws {
        var cardData = try cardToDictionary(card)
        cardData["updatedAt"] = FieldValue.serverTimestamp()

        try await db.collection("users").document(userID)
            .collection("businessCards").document(cardID).updateData(cardData)
    }

    // MARK: - Delete Business Card
    func deleteBusinessCard(userID: String, cardID: String) async throws {
        try await db.collection("users").document(userID)
            .collection("businessCards").document(cardID).delete()
    }

    // MARK: - Get Business Cards
    func getBusinessCards(userID: String) async throws -> [[String: Any]] {
        let snapshot = try await db.collection("users").document(userID)
            .collection("businessCards")
            .order(by: "createdAt", descending: true)
            .getDocuments()

        return snapshot.documents.map { doc in
            var data = doc.data()
            data["id"] = doc.documentID
            return data
        }
    }

    // MARK: - Get Single Business Card
    func getBusinessCard(userID: String, cardID: String) async throws -> [String: Any]? {
        let document = try await db.collection("users").document(userID)
            .collection("businessCards").document(cardID).getDocument()

        guard var data = document.data() else { return nil }
        data["id"] = document.documentID
        return data
    }

    // MARK: - Helper: Convert Card to Dictionary
    private func cardToDictionary(_ card: BusinessCard) throws -> [String: Any] {
        var dict: [String: Any] = [
            "firstName": card.firstName,
            "lastName": card.lastName,
            "title": card.title,
            "company": card.company,
            "email": card.email,
            "phone": card.phone,
            "website": card.website,
            "address": card.address,
            "city": card.city,
            "state": card.state,
            "zipCode": card.zipCode,
            "country": card.country,
            "primaryColor": card.primaryColor,
            "secondaryColor": card.secondaryColor,
            "cardLayout": card.cardLayout,
            "linkedInURL": card.linkedInURL,
            "twitterURL": card.twitterURL,
            "instagramURL": card.instagramURL,
            "facebookURL": card.facebookURL,
            "githubURL": card.githubURL,
            "deepLinkURL": card.deepLinkURL,
            "isInWallet": card.isInWallet,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]

        // Convert logo data to Base64 string if exists
        if let logoData = card.logoData {
            dict["logoBase64"] = logoData.base64EncodedString()
        }

        // Convert QR code data to Base64 string if exists
        if let qrCodeData = card.qrCodeData {
            dict["qrCodeBase64"] = qrCodeData.base64EncodedString()
        }

        return dict
    }
}
