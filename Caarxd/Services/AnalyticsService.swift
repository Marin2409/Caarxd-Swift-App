//
//  AnalyticsService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftData

class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func trackEvent(
        type: EventType,
        businessCardID: UUID? = nil,
        metadata: [String: Any] = [:],
        modelContext: ModelContext
    ) {
        let event = AnalyticsEvent(
            eventType: type,
            businessCardID: businessCardID,
            metadata: metadata
        )

        modelContext.insert(event)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save analytics event: \(error)")
        }
    }

    func trackCardView(businessCardID: UUID, modelContext: ModelContext) {
        trackEvent(
            type: .view,
            businessCardID: businessCardID,
            metadata: ["timestamp": Date().timeIntervalSince1970],
            modelContext: modelContext
        )
    }

    func trackCardShare(businessCardID: UUID, shareMethod: String, modelContext: ModelContext) {
        trackEvent(
            type: .share,
            businessCardID: businessCardID,
            metadata: ["method": shareMethod],
            modelContext: modelContext
        )
    }

    func trackContactSave(businessCardID: UUID, modelContext: ModelContext) {
        trackEvent(
            type: .contactSave,
            businessCardID: businessCardID,
            modelContext: modelContext
        )
    }

    func trackLinkClick(businessCardID: UUID, linkType: String, modelContext: ModelContext) {
        trackEvent(
            type: .linkClick,
            businessCardID: businessCardID,
            metadata: ["linkType": linkType],
            modelContext: modelContext
        )
    }

    func trackWalletAdd(businessCardID: UUID, modelContext: ModelContext) {
        trackEvent(
            type: .walletAdd,
            businessCardID: businessCardID,
            modelContext: modelContext
        )
    }

    func trackQRScan(businessCardID: UUID?, modelContext: ModelContext) {
        trackEvent(
            type: .qrScan,
            businessCardID: businessCardID,
            modelContext: modelContext
        )
    }
}
