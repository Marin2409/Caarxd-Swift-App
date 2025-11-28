//
//  User.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var profileImageData: Data?
    var createdAt: Date
    var updatedAt: Date

    init(
        firstName: String = "",
        lastName: String = "",
        email: String = "",
        phone: String = ""
    ) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
