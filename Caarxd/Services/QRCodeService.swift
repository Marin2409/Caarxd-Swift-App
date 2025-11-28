//
//  QRCodeService.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import CoreImage
import UIKit

class QRCodeService {
    static let shared = QRCodeService()

    private init() {}

    func generateQRCode(from businessCard: BusinessCard) -> Data? {
        let vCardString = generateVCard(from: businessCard)
        return generateQRCodeImage(from: vCardString)
    }

    func generateQRCodeImage(from string: String, size: CGSize = CGSize(width: 512, height: 512)) -> Data? {
        let data = string.data(using: .utf8)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }

        let scaleX = size.width / outputImage.extent.size.width
        let scaleY = size.height / outputImage.extent.size.height
        let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        let context = CIContext()
        guard let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) else { return nil }

        let uiImage = UIImage(cgImage: cgImage)
        return uiImage.pngData()
    }

    func generateVCard(from businessCard: BusinessCard) -> String {
        var vCard = """
        BEGIN:VCARD
        VERSION:3.0
        FN:\(businessCard.fullName)
        N:\(businessCard.lastName);\(businessCard.firstName);;;
        """

        if !businessCard.title.isEmpty {
            vCard += "\nTITLE:\(businessCard.title)"
        }

        if !businessCard.company.isEmpty {
            vCard += "\nORG:\(businessCard.company)"
        }

        if !businessCard.email.isEmpty {
            vCard += "\nEMAIL;TYPE=WORK:\(businessCard.email)"
        }

        if !businessCard.phone.isEmpty {
            vCard += "\nTEL;TYPE=WORK,VOICE:\(businessCard.phone)"
        }

        if !businessCard.website.isEmpty {
            vCard += "\nURL:\(businessCard.website)"
        }

        if !businessCard.address.isEmpty || !businessCard.city.isEmpty || !businessCard.state.isEmpty {
            vCard += "\nADR;TYPE=WORK:;;\(businessCard.address);\(businessCard.city);\(businessCard.state);\(businessCard.zipCode);\(businessCard.country)"
        }

        if !businessCard.linkedInURL.isEmpty {
            vCard += "\nURL;type=LinkedIn:\(businessCard.linkedInURL)"
        }

        vCard += "\nEND:VCARD"

        return vCard
    }

    func generateDeepLink(for businessCard: BusinessCard) -> String {
        return "caarxd://card/\(businessCard.id.uuidString)"
    }
}
