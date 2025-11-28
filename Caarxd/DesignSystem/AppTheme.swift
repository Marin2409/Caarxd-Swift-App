//
//  AppTheme.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

// MARK: - Design System
struct DesignSystem {

    // MARK: - Colors (Adaptive Monochrome)
    struct Colors {
        // Primary Monochrome Scale
        static let primary = Color.primary // Adapts to light/dark mode
        static let secondary = Color.secondary

        // Grayscale (Adaptive)
        static let background = Color(uiColor: .systemBackground)
        static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
        static let tertiaryBackground = Color(uiColor: .tertiarySystemBackground)

        static let surface = Color(uiColor: .systemGray6)
        static let surfaceElevated = Color(uiColor: .systemGray5)

        // Borders & Dividers
        static let border = Color(uiColor: .separator)
        static let divider = Color(uiColor: .separator).opacity(0.5)

        // Text
        static let text = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color(uiColor: .tertiaryLabel)

        // Accent (Minimal - Single blue)
        static let accent = Color(red: 0.0, green: 0.48, blue: 1.0) // Pure blue
        static let accentSubtle = Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.1)

        // Semantic (Only when necessary)
        static let success = Color.green
        static let error = Color.red
        static let warning = Color.orange
    }

    // MARK: - Typography
    struct Typography {
        // Display
        static let displayLarge = Font.system(size: 56, weight: .bold, design: .default)
        static let displayMedium = Font.system(size: 44, weight: .bold, design: .default)
        static let displaySmall = Font.system(size: 36, weight: .semibold, design: .default)

        // Titles
        static let title1 = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)

        // Headlines
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let subheadline = Font.system(size: 15, weight: .medium, design: .default)

        // Body
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyEmphasized = Font.system(size: 17, weight: .medium, design: .default)

        // Caption
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let captionEmphasized = Font.system(size: 12, weight: .medium, design: .default)
    }

    // MARK: - Spacing (Maximum Whitespace)
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }

    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 9999
    }

    // MARK: - Shadows
    struct Shadows {
        static let subtle = Shadow(
            color: Color.black.opacity(0.05),
            radius: 4,
            x: 0,
            y: 2
        )

        static let medium = Shadow(
            color: Color.black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 4
        )

        static let elevated = Shadow(
            color: Color.black.opacity(0.15),
            radius: 16,
            x: 0,
            y: 8
        )
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .background(DesignSystem.Colors.surface)
            .cornerRadius(DesignSystem.CornerRadius.lg)
    }

    func primaryButton() -> some View {
        self
            .font(DesignSystem.Typography.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.accent)
            .cornerRadius(DesignSystem.CornerRadius.md)
    }

    func secondaryButton() -> some View {
        self
            .font(DesignSystem.Typography.headline)
            .foregroundColor(DesignSystem.Colors.accent)
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.accentSubtle)
            .cornerRadius(DesignSystem.CornerRadius.md)
    }

    func destructiveButton() -> some View {
        self
            .font(DesignSystem.Typography.headline)
            .foregroundColor(DesignSystem.Colors.error)
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.error.opacity(0.1))
            .cornerRadius(DesignSystem.CornerRadius.md)
    }
}
