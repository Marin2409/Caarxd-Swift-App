//
//  Contact.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftData

@Model
final class Contact {
    var id: UUID
    var createdAt: Date
    var scannedAt: Date?

    // Contact Information
    var firstName: String
    var lastName: String
    var title: String
    var company: String
    var email: String
    var phone: String
    var website: String
    var address: String

    // Additional Details
    var notes: String
    var isFavorite: Bool
    var tags: [String]

    // Source Information
    var scannedFromQR: Bool
    var scannedFromCard: Bool
    var sourceCardID: String? // Reference to original business card if scanned

    // Sync Status
    var syncedToContacts: Bool
    var contactsAppID: String? // iOS Contacts app identifier

    // Card Preview
    var cardImageData: Data?

    init(
        firstName: String = "",
        lastName: String = "",
        title: String = "",
        company: String = "",
        email: String = "",
        phone: String = "",
        website: String = "",
        address: String = "",
        notes: String = "",
        scannedFromQR: Bool = false,
        scannedFromCard: Bool = false
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.scannedAt = Date()
        self.firstName = firstName
        self.lastName = lastName
        self.title = title
        self.company = company
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.notes = notes
        self.isFavorite = false
        self.tags = []
        self.scannedFromQR = scannedFromQR
        self.scannedFromCard = scannedFromCard
        self.syncedToContacts = false
    }

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
