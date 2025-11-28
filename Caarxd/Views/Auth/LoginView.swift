//
//  LoginView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    Spacer()
                        .frame(height: DesignSystem.Spacing.xxxl)

                    // Logo and Title
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.system(size: 64))
                            .foregroundColor(DesignSystem.Colors.accent)

                        Text("Welcome Back")
                            .font(DesignSystem.Typography.displayMedium)
                            .foregroundColor(DesignSystem.Colors.text)

                        Text("Sign in to continue")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }

                    // Form
                    VStack(spacing: DesignSystem.Spacing.md) {
                        TextField("Email", text: $email)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        SecureField("Password", text: $password)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    // Login Button
                    Button(action: handleLogin) {
                        Text("Sign In")
                            .primaryButton()
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1.0)
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    Spacer()
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Login Failed", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func handleLogin() {
        let authState = AuthState.shared

        Task {
            let success = await authState.login(email: email, password: password)

            if success {
                authState.markWelcomeSlidesAsSeen()
                dismiss()
            } else {
                errorMessage = authState.errorMessage ?? "Invalid email or password. Please try again."
                showingError = true
            }
        }
    }
}

#Preview {
    LoginView()
}
