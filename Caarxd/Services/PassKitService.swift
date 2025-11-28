//
//  PassKitService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import PassKit

class PassKitService {
    static let shared = PassKitService()

    private init() {}

    func addBusinessCardToWallet(_ businessCard: BusinessCard) throws {
        // Note: This requires a configured Pass Type ID and signing certificates from Apple Developer
        // For a complete implementation, you'll need:
        // 1. Apple Developer Account with Pass Type ID
        // 2. Pass signing certificate
        // 3. Backend server to generate and sign passes

        // This is a simplified version showing the structure
        let pass = createPass(from: businessCard)

        // In production, you would:
        // 1. Send card data to your backend
        // 2. Backend generates signed .pkpass file
        // 3. Download and present pass to PKAddPassesViewController

        presentPassViewController(with: pass)
    }

    func addWorkCardToWallet(_ workCard: WorkCard) throws {
        let pass = createPass(from: workCard)
        presentPassViewController(with: pass)
    }

    private func createPass(from businessCard: BusinessCard) -> PKPass? {
        // This would be replaced with actual pass data from your backend
        // For now, returning nil as this requires backend integration
        return nil
    }

    private func createPass(from workCard: WorkCard) -> PKPass? {
        // This would be replaced with actual pass data from your backend
        return nil
    }

    private func presentPassViewController(with pass: PKPass?) {
        guard let pass = pass else {
            print("Pass creation failed - backend integration required")
            return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }

        guard let passViewController = PKAddPassesViewController(pass: pass) else {
            print("Failed to create pass view controller")
            return
        }
        rootViewController.present(passViewController, animated: true)
    }

    // Helper method to check if device supports Apple Wallet
    func isWalletAvailable() -> Bool {
        return PKPassLibrary.isPassLibraryAvailable()
    }

    // Helper method to check if a pass can be added
    func canAddPasses() -> Bool {
        return PKAddPassesViewController.canAddPasses()
    }
}

// MARK: - Pass Structure Helper
struct PassData {
    let passTypeIdentifier: String
    let serialNumber: String
    let teamIdentifier: String
    let organizationName: String
    let description: String

    // Card specific data
    let headerFields: [PassField]
    let primaryFields: [PassField]
    let secondaryFields: [PassField]
    let auxiliaryFields: [PassField]
    let backFields: [PassField]

    // Visual
    let backgroundColor: String
    let foregroundColor: String
    let labelColor: String
    let logoText: String
}

struct PassField {
    let key: String
    let label: String
    let value: String
}
