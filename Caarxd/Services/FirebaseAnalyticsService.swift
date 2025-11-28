//
//  FirebaseAnalyticsService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAnalytics

class FirebaseAnalyticsService {
    static let shared = FirebaseAnalyticsService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Track Card Event
    func trackCardEvent(
        userID: String,
        cardID: String,
        eventType: String,
        metadata: [String: Any] = [:]
    ) async throws {
        var eventData: [String: Any] = [
            "eventType": eventType,
            "cardID": cardID,
            "timestamp": FieldValue.serverTimestamp(),
            "metadata": metadata
        ]

        // Add to Firestore
        try await db.collection("users").document(userID)
            .collection("analytics").addDocument(data: eventData)

        // Log to Firebase Analytics
        var analyticsParams: [String: Any] = [
            "card_id": cardID,
            "event_type": eventType
        ]
        analyticsParams.merge(metadata) { _, new in new }

        Analytics.logEvent("card_\(eventType)", parameters: analyticsParams)
    }

    // MARK: - Get Card Analytics
    func getCardAnalytics(
        userID: String,
        cardID: String,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) async throws -> [[String: Any]] {
        var query: Query = db.collection("users").document(userID)
            .collection("analytics")
            .whereField("cardID", isEqualTo: cardID)
            .order(by: "timestamp", descending: true)

        if let startDate = startDate {
            query = query.whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: startDate))
        }

        if let endDate = endDate {
            query = query.whereField("timestamp", isLessThanOrEqualTo: Timestamp(date: endDate))
        }

        let snapshot = try await query.getDocuments()
        return snapshot.documents.map { $0.data() }
    }

    // MARK: - Get All User Analytics
    func getAllUserAnalytics(
        userID: String,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) async throws -> [[String: Any]] {
        var query: Query = db.collection("users").document(userID)
            .collection("analytics")
            .order(by: "timestamp", descending: true)

        if let startDate = startDate {
            query = query.whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: startDate))
        }

        if let endDate = endDate {
            query = query.whereField("timestamp", isLessThanOrEqualTo: Timestamp(date: endDate))
        }

        let snapshot = try await query.getDocuments()
        return snapshot.documents.map { $0.data() }
    }

    // MARK: - Get Analytics Summary
    func getAnalyticsSummary(userID: String, cardID: String) async throws -> [String: Int] {
        let analytics = try await getCardAnalytics(userID: userID, cardID: cardID)

        var summary: [String: Int] = [
            "views": 0,
            "shares": 0,
            "contactSaves": 0,
            "linkClicks": 0
        ]

        for event in analytics {
            guard let eventType = event["eventType"] as? String else { continue }

            switch eventType {
            case "view":
                summary["views", default: 0] += 1
            case "share":
                summary["shares", default: 0] += 1
            case "contact_save", "contactSave":
                summary["contactSaves", default: 0] += 1
            case "link_click", "linkClick":
                summary["linkClicks", default: 0] += 1
            default:
                break
            }
        }

        return summary
    }

    // MARK: - Track Screen View
    func trackScreenView(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ])
    }
}
