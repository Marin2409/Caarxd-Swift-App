//
//  ThemeSettingsView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct ThemeSettingsView: View {
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Appearance")
                            .font(DesignSystem.Typography.displaySmall)
                            .foregroundColor(DesignSystem.Colors.text)

                        Text("Choose how Caarxd looks")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.top, DesignSystem.Spacing.lg)

                    // Theme Options
                    VStack(spacing: DesignSystem.Spacing.md) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Button(action: {
                                appTheme = theme
                            }) {
                                HStack(spacing: DesignSystem.Spacing.md) {
                                    Image(systemName: theme.icon)
                                        .font(.title3)
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                        .frame(width: 32)

                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        Text(theme.displayName)
                                            .font(DesignSystem.Typography.headline)
                                            .foregroundColor(DesignSystem.Colors.text)

                                        Text(theme.description)
                                            .font(DesignSystem.Typography.caption)
                                            .foregroundColor(DesignSystem.Colors.textSecondary)
                                    }

                                    Spacer()

                                    if appTheme == theme {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(DesignSystem.Colors.accent)
                                    } else {
                                        Circle()
                                            .stroke(DesignSystem.Colors.border, lineWidth: 2)
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                .padding(DesignSystem.Spacing.md)
                                .background(appTheme == theme ? DesignSystem.Colors.accentSubtle : DesignSystem.Colors.surface)
                                .cornerRadius(DesignSystem.CornerRadius.md)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                        .stroke(appTheme == theme ? DesignSystem.Colors.accent : DesignSystem.Colors.border, lineWidth: appTheme == theme ? 2 : 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    Spacer()
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Theme")
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
}

enum AppTheme: String, CaseIterable, Codable {
    case light
    case dark
    case system

    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }

    var description: String {
        switch self {
        case .light: return "Always use light mode"
        case .dark: return "Always use dark mode"
        case .system: return "Match system settings"
        }
    }

    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "circle.lefthalf.filled"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

#Preview {
    ThemeSettingsView()
}
