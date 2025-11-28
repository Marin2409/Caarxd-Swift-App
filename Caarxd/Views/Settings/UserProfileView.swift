//
//  UserProfileView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct UserProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]

    @State private var showingEditProfile = false

    private var currentUser: User? {
        users.first
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // Profile Picture
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        if let user = currentUser,
                           let imageData = user.profileImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(DesignSystem.Colors.border, lineWidth: 2))
                        } else {
                            Circle()
                                .fill(DesignSystem.Colors.surface)
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                )
                                .overlay(Circle().stroke(DesignSystem.Colors.border, lineWidth: 2))
                        }

                        if let user = currentUser {
                            Text(user.fullName)
                                .font(DesignSystem.Typography.title1)
                                .foregroundColor(DesignSystem.Colors.text)

                            Text(user.email)
                                .font(DesignSystem.Typography.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        } else {
                            Text("No Profile")
                                .font(DesignSystem.Typography.title1)
                                .foregroundColor(DesignSystem.Colors.text)

                            Text("Create your profile")
                                .font(DesignSystem.Typography.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.lg)

                    // Edit Profile Button
                    Button(action: { showingEditProfile = true }) {
                        Label("Edit Profile", systemImage: "pencil")
                            .primaryButton()
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    // Profile Information
                    if let user = currentUser {
                        VStack(spacing: DesignSystem.Spacing.md) {
                            ProfileInfoRow(icon: "person.fill", title: "Name", value: user.fullName)
                            ProfileInfoRow(icon: "envelope.fill", title: "Email", value: user.email)

                            if !user.phone.isEmpty {
                                ProfileInfoRow(icon: "phone.fill", title: "Phone", value: user.phone)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                    } else {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                .font(.system(size: 48))
                                .foregroundColor(DesignSystem.Colors.textTertiary)

                            Text("No profile information")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.text)

                            Text("Tap Edit Profile to add your information")
                                .font(DesignSystem.Typography.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(DesignSystem.Spacing.lg)
                    }

                    // Logout Button
                    Button(action: handleLogout) {
                        Label("Logout", systemImage: "arrow.right.square")
                            .destructiveButton()
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.top, DesignSystem.Spacing.lg)

                    Spacer()
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: currentUser)
            }
        }
    }

    private func handleLogout() {
        AuthState.shared.logout()
        dismiss()
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.textTertiary)

                Text(value)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.text)
            }

            Spacer()
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                .stroke(DesignSystem.Colors.border, lineWidth: 1)
        )
    }
}

#Preview {
    UserProfileView()
}
