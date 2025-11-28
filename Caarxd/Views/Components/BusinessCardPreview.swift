//
//  BusinessCardPreview.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct BusinessCardPreview: View {
    let card: BusinessCard

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            // Header with Logo
            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                if let logoData = card.logoData, let uiImage = UIImage(data: logoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(card.firstName.prefix(1))
                                .font(DesignSystem.Typography.title1)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                }

                Spacer()
            }

            Spacer()

            // Name and Title
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(card.fullName)
                    .font(DesignSystem.Typography.displaySmall)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(card.title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(.white)

                if !card.company.isEmpty {
                    Text(card.company)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(.white)
                }
            }

            // Contact Info
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                if !card.email.isEmpty {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "envelope")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text(card.email)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(.white)
                    }
                }

                if !card.phone.isEmpty {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "phone")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text(card.phone)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(.white)
                    }
                }

                if !card.website.isEmpty {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "link")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text(card.website)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 280)
        .padding(DesignSystem.Spacing.xl)
        .background(
            Color(hex: card.primaryColor) ?? DesignSystem.Colors.accent
        )
        .cornerRadius(DesignSystem.CornerRadius.lg)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// Helper extension for Color from hex
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    let card = BusinessCard(
        firstName: "John",
        lastName: "Doe",
        title: "Software Engineer",
        company: "Tech Co",
        email: "john@example.com",
        phone: "555-0100",
        website: "example.com",
        primaryColor: "#007AFF"
    )

    return BusinessCardPreview(card: card)
        .padding()
}
