//
//  BusinessCard.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class BusinessCard {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date

    // Basic Information
    var firstName: String
    var lastName: String
    var title: String
    var company: String
    var email: String
    var phone: String
    var website: String

    // Additional Information
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var country: String

    // Customization
    var logoData: Data?
    var primaryColor: String // Hex color
    var secondaryColor: String // Hex color
    var cardLayout: String // Layout style identifier

    // Social Media Links
    var linkedInURL: String
    var twitterURL: String
    var instagramURL: String
    var facebookURL: String
    var githubURL: String
    var customLinks: [String] // JSON array of custom social links

    // QR Code
    var qrCodeData: Data?
    var deepLinkURL: String

    // Apple Wallet
    var isInWallet: Bool
    var walletPassID: String?

    // Relationships
    @Relationship(deleteRule: .cascade) var analytics: [AnalyticsEvent]?

    init(
        firstName: String = "",
        lastName: String = "",
        title: String = "",
        company: String = "",
        email: String = "",
        phone: String = "",
        website: String = "",
        address: String = "",
        city: String = "",
        state: String = "",
        zipCode: String = "",
        country: String = "",
        primaryColor: String = "#007AFF",
        secondaryColor: String = "#5856D6"
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.updatedAt = Date()
        self.firstName = firstName
        self.lastName = lastName
        self.title = title
        self.company = company
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.cardLayout = "default"
        self.linkedInURL = ""
        self.twitterURL = ""
        self.instagramURL = ""
        self.facebookURL = ""
        self.githubURL = ""
        self.customLinks = []
        self.deepLinkURL = ""
        self.isInWallet = false
        self.walletPassID = nil
    }

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
