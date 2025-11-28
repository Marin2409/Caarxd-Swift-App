//
//  AnalyticsEvent.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftData

enum EventType: String, Codable {
    case view = "view"
    case share = "share"
    case contactSave = "contact_save"
    case linkClick = "link_click"
    case walletAdd = "wallet_add"
    case qrScan = "qr_scan"
}

@Model
final class AnalyticsEvent {
    var id: UUID
    var timestamp: Date
    var eventType: String // Using String to store EventType.rawValue
    var metadata: String // JSON string for additional data

    // Location data (optional)
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var country: String?

    // Device/Platform info
    var deviceType: String
    var osVersion: String

    // Related to which card
    var businessCardID: UUID?

    init(
        eventType: EventType,
        businessCardID: UUID? = nil,
        metadata: [String: Any] = [:]
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.eventType = eventType.rawValue
        self.businessCardID = businessCardID
        self.deviceType = "iOS"
        self.osVersion = ProcessInfo.processInfo.operatingSystemVersionString

        // Convert metadata dictionary to JSON string
        if let jsonData = try? JSONSerialization.data(withJSONObject: metadata),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            self.metadata = jsonString
        } else {
            self.metadata = "{}"
        }
    }
}
