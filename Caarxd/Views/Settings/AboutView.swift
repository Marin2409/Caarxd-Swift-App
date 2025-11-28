//
//  AboutView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // App Icon and Name
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.system(size: 80))
                            .foregroundColor(DesignSystem.Colors.accent)

                        Text("Caarxd")
                            .font(DesignSystem.Typography.displayMedium)
                            .foregroundColor(DesignSystem.Colors.text)

                        Text("Digital Business Cards")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)

                        Text("Version \(appVersion())")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                    }
                    .padding(.top, DesignSystem.Spacing.xxxl)

                    // Description
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                        Text("About")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                            .textCase(.uppercase)
                            .tracking(1)

                        Text("Caarxd is your modern digital business card wallet. Create beautiful, professional business cards and share them instantly via QR code, link, or contact export.")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.text)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                    }

                    // Features
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                        Text("Features")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                            .textCase(.uppercase)
                            .tracking(1)

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            featureRow(icon: "person.crop.rectangle", text: "Create digital business cards")
                            featureRow(icon: "qrcode", text: "Generate QR codes instantly")
                            featureRow(icon: "square.and.arrow.up", text: "Share via multiple channels")
                            featureRow(icon: "chart.line.uptrend.xyaxis", text: "Track card performance")
                            featureRow(icon: "person.badge.plus", text: "Export to iOS Contacts")
                            featureRow(icon: "lock.shield", text: "Secure cloud sync")
                        }
                        .padding(DesignSystem.Spacing.md)
                        .background(DesignSystem.Colors.surface)
                        .cornerRadius(DesignSystem.CornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                .stroke(DesignSystem.Colors.border, lineWidth: 1)
                        )
                    }

                    // Credits
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                        Text("Acknowledgements")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                            .textCase(.uppercase)
                            .tracking(1)

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            Text("Built with:")
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundColor(DesignSystem.Colors.text)

                            creditRow(name: "SwiftUI", description: "Apple's UI framework")
                            creditRow(name: "Firebase", description: "Backend infrastructure")
                            creditRow(name: "VisionKit", description: "OCR & document scanning")
                            creditRow(name: "CoreImage", description: "QR code generation")
                        }
                        .padding(DesignSystem.Spacing.md)
                        .background(DesignSystem.Colors.surface)
                        .cornerRadius(DesignSystem.CornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                .stroke(DesignSystem.Colors.border, lineWidth: 1)
                        )
                    }

                    // Copyright
                    Text("© 2024 Caarxd. All rights reserved.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                        .padding(.bottom, DesignSystem.Spacing.xxxl)

                    Spacer()
                }
                .padding(DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Feature Row
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(DesignSystem.Colors.accent)
                .frame(width: 24)

            Text(text)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.text)
        }
    }

    // MARK: - Credit Row
    private func creditRow(name: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            Text(name)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.text)

            Text(description)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }

    // MARK: - Helper
    private func appVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

#Preview {
    AboutView()
}
