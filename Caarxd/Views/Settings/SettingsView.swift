//
//  SettingsView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingProfile = false
    @State private var showingThemes = false
    @State private var showingAbout = false
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // Account Section
                    settingsSection(title: "Account") {
                        settingsRow(
                            icon: "person.circle",
                            title: "Profile",
                            action: { showingProfile = true }
                        )

                        settingsRow(
                            icon: "arrow.right.square",
                            title: "Logout",
                            color: DesignSystem.Colors.error,
                            action: { showingLogoutAlert = true }
                        )
                    }

                    // Appearance Section
                    settingsSection(title: "Appearance") {
                        settingsRow(
                            icon: "circle.lefthalf.filled",
                            title: "Theme",
                            action: { showingThemes = true }
                        )
                    }

                    // Support Section
                    settingsSection(title: "Support") {
                        settingsRow(
                            icon: "questionmark.circle",
                            title: "Help & FAQ",
                            action: { openURL("https://caarxd.app/help") }
                        )

                        settingsRow(
                            icon: "envelope",
                            title: "Contact Support",
                            subtitle: "support@caarxd.app",
                            action: { openEmail() }
                        )

                        settingsRow(
                            icon: "star",
                            title: "Rate Caarxd",
                            action: { requestReview() }
                        )
                    }

                    // Legal Section
                    settingsSection(title: "Legal") {
                        settingsRow(
                            icon: "hand.raised",
                            title: "Privacy Policy",
                            action: { openURL("https://caarxd.app/privacy") }
                        )

                        settingsRow(
                            icon: "doc.text",
                            title: "Terms of Service",
                            action: { openURL("https://caarxd.app/terms") }
                        )

                        settingsRow(
                            icon: "shield",
                            title: "Data & Privacy",
                            action: { showingAbout = true }
                        )
                    }

                    // About Section
                    settingsSection(title: "About") {
                        settingsRow(
                            icon: "info.circle",
                            title: "About Caarxd",
                            subtitle: "Version \(appVersion())",
                            action: { showingAbout = true }
                        )

                        settingsRow(
                            icon: "heart",
                            title: "Acknowledgements",
                            action: { showingAbout = true }
                        )
                    }

                    Spacer()
                }
                .padding(DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                UserProfileView()
            }
            .sheet(isPresented: $showingThemes) {
                ThemeSettingsView()
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    handleLogout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }

    // MARK: - Settings Section
    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(title)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(1)

            VStack(spacing: 0) {
                content()
            }
            .background(DesignSystem.Colors.surface)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
            )
        }
    }

    // MARK: - Settings Row
    private func settingsRow(
        icon: String,
        title: String,
        subtitle: String? = nil,
        color: Color = DesignSystem.Colors.text,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(color)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .padding(DesignSystem.Spacing.md)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helper Methods
    private func handleLogout() {
        AuthState.shared.logout()
        dismiss()
    }

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    private func openEmail() {
        if let url = URL(string: "mailto:support@caarxd.app") {
            UIApplication.shared.open(url)
        }
    }

    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func appVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

#Preview {
    SettingsView()
}
