//
//  ContactExportService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import Contacts
import SwiftUI

class ContactExportService {
    static let shared = ContactExportService()
    private let store = CNContactStore()

    private init() {}

    // MARK: - Request Contacts Permission
    func requestAccess() async throws -> Bool {
        return try await store.requestAccess(for: .contacts)
    }

    // MARK: - Check Permission Status
    func checkPermissionStatus() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }

    // MARK: - Export BusinessCard to Contacts
    func exportBusinessCardToContacts(_ card: BusinessCard) async throws -> String {
        // Request permission if not granted
        let status = checkPermissionStatus()
        if status != .authorized {
            let granted = try await requestAccess()
            if !granted {
                throw ContactExportError.permissionDenied
            }
        }

        // Create mutable contact
        let contact = CNMutableContact()

        // Name
        contact.givenName = card.firstName
        contact.familyName = card.lastName

        // Organization
        if !card.company.isEmpty {
            contact.organizationName = card.company
        }

        if !card.title.isEmpty {
            contact.jobTitle = card.title
        }

        // Email
        if !card.email.isEmpty {
            let email = CNLabeledValue(
                label: CNLabelWork,
                value: card.email as NSString
            )
            contact.emailAddresses = [email]
        }

        // Phone
        if !card.phone.isEmpty {
            let phoneNumber = CNPhoneNumber(stringValue: card.phone)
            let phone = CNLabeledValue(
                label: CNLabelWork,
                value: phoneNumber
            )
            contact.phoneNumbers = [phone]
        }

        // Postal Address
        if !card.address.isEmpty || !card.city.isEmpty {
            let address = CNMutablePostalAddress()
            address.street = card.address
            address.city = card.city
            address.state = card.state
            address.postalCode = card.zipCode
            address.country = card.country

            let postalAddress = CNLabeledValue(
                label: CNLabelWork,
                value: address as CNPostalAddress
            )
            contact.postalAddresses = [postalAddress]
        }

        // URLs
        var urls: [CNLabeledValue<NSString>] = []

        if !card.website.isEmpty {
            let url = CNLabeledValue(
                label: CNLabelHome,
                value: card.website as NSString
            )
            urls.append(url)
        }

        if !card.linkedInURL.isEmpty {
            let url = CNLabeledValue(
                label: "LinkedIn",
                value: card.linkedInURL as NSString
            )
            urls.append(url)
        }

        if !card.twitterURL.isEmpty {
            let url = CNLabeledValue(
                label: "Twitter",
                value: card.twitterURL as NSString
            )
            urls.append(url)
        }

        if !card.instagramURL.isEmpty {
            let url = CNLabeledValue(
                label: "Instagram",
                value: card.instagramURL as NSString
            )
            urls.append(url)
        }

        if !urls.isEmpty {
            contact.urlAddresses = urls
        }

        // Add logo as image
        if let logoData = card.logoData, let image = UIImage(data: logoData) {
            contact.imageData = image.jpegData(compressionQuality: 0.8)
        }

        // Note - add card ID for tracking
        contact.note = "Imported from Caarxd - ID: \(card.id.uuidString)"

        // Save contact
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)

        try store.execute(saveRequest)

        // Return contact identifier
        return contact.identifier
    }

    // MARK: - Export Contact to iOS Contacts
    func exportContactToContacts(_ contact: Contact) async throws -> String {
        // Request permission if not granted
        let status = checkPermissionStatus()
        if status != .authorized {
            let granted = try await requestAccess()
            if !granted {
                throw ContactExportError.permissionDenied
            }
        }

        // Create mutable contact
        let cnContact = CNMutableContact()

        // Name
        cnContact.givenName = contact.firstName
        cnContact.familyName = contact.lastName

        // Company
        if !contact.company.isEmpty {
            cnContact.organizationName = contact.company
        }

        // Email
        if !contact.email.isEmpty {
            let email = CNLabeledValue(
                label: CNLabelWork,
                value: contact.email as NSString
            )
            cnContact.emailAddresses = [email]
        }

        // Phone
        if !contact.phone.isEmpty {
            let phoneNumber = CNPhoneNumber(stringValue: contact.phone)
            let phone = CNLabeledValue(
                label: CNLabelWork,
                value: phoneNumber
            )
            cnContact.phoneNumbers = [phone]
        }

        // Note
        if !contact.notes.isEmpty {
            cnContact.note = contact.notes
        }

        // Save contact
        let saveRequest = CNSaveRequest()
        saveRequest.add(cnContact, toContainerWithIdentifier: nil)

        try store.execute(saveRequest)

        return cnContact.identifier
    }

    // MARK: - Update Existing Contact
    func updateContact(identifier: String, with card: BusinessCard) async throws {
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactJobTitleKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor,
            CNContactUrlAddressesKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactNoteKey as CNKeyDescriptor
        ]

        guard let contact = try? store.unifiedContact(withIdentifier: identifier, keysToFetch: keys) else {
            throw ContactExportError.contactNotFound
        }

        let mutableContact = contact.mutableCopy() as! CNMutableContact

        // Update fields (same as create)
        mutableContact.givenName = card.firstName
        mutableContact.familyName = card.lastName

        if !card.company.isEmpty {
            mutableContact.organizationName = card.company
        }

        if !card.title.isEmpty {
            mutableContact.jobTitle = card.title
        }

        // Save changes
        let saveRequest = CNSaveRequest()
        saveRequest.update(mutableContact)

        try store.execute(saveRequest)
    }

    // MARK: - Delete Contact
    func deleteContact(identifier: String) async throws {
        let keys: [CNKeyDescriptor] = [CNContactIdentifierKey as CNKeyDescriptor]

        guard let contact = try? store.unifiedContact(withIdentifier: identifier, keysToFetch: keys) else {
            throw ContactExportError.contactNotFound
        }

        let mutableContact = contact.mutableCopy() as! CNMutableContact

        let saveRequest = CNSaveRequest()
        saveRequest.delete(mutableContact)

        try store.execute(saveRequest)
    }
}

// MARK: - Error Types
enum ContactExportError: LocalizedError {
    case permissionDenied
    case contactNotFound
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Permission to access contacts was denied. Please enable in Settings."
        case .contactNotFound:
            return "Contact not found in your device."
        case .saveFailed:
            return "Failed to save contact. Please try again."
        }
    }
}
