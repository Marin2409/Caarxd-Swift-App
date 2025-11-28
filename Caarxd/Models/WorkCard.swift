//
//  WorkCard.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftData

enum WorkCardType: String, Codable {
    case employeeID = "employee_id"
    case buildingAccess = "building_access"
    case membership = "membership"
    case other = "other"
}

@Model
final class WorkCard {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date

    // Basic Information
    var cardName: String
    var cardType: String // WorkCardType.rawValue
    var company: String
    var employeeName: String
    var employeeID: String

    // Card Details
    var cardImageData: Data?
    var barcodeData: String?
    var barcodeFormat: String? // QR, Code128, etc.

    // Apple Wallet
    var isInWallet: Bool
    var walletPassID: String?

    // Additional Information
    var expiryDate: Date?
    var notes: String
    var isActive: Bool

    init(
        cardName: String = "",
        cardType: WorkCardType = .employeeID,
        company: String = "",
        employeeName: String = "",
        employeeID: String = ""
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.updatedAt = Date()
        self.cardName = cardName
        self.cardType = cardType.rawValue
        self.company = company
        self.employeeName = employeeName
        self.employeeID = employeeID
        self.isInWallet = false
        self.notes = ""
        self.isActive = true
    }
}
