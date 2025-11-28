//
//  SharingService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import SwiftUI
import LinkPresentation

class SharingService {
    static let shared = SharingService()

    private init() {}

    func shareBusinessCard(_ businessCard: BusinessCard, from viewController: UIViewController) {
        var itemsToShare: [Any] = []

        // Add vCard data
        let vCardString = QRCodeService.shared.generateVCard(from: businessCard)
        if let vCardData = vCardString.data(using: .utf8) {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(businessCard.fullName).vcf")
            try? vCardData.write(to: tempURL)
            itemsToShare.append(tempURL)
        }

        // Add QR code image
        if let qrCodeData = businessCard.qrCodeData, let image = UIImage(data: qrCodeData) {
            itemsToShare.append(image)
        }

        // Add deep link
        let deepLink = QRCodeService.shared.generateDeepLink(for: businessCard)
        itemsToShare.append(deepLink)

        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        // For iPad
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        viewController.present(activityVC, animated: true)
    }
}
