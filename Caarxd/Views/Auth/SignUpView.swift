//
//  SignUpView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
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
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 64))
                            .foregroundColor(DesignSystem.Colors.accent)

                        Text("Create Account")
                            .font(DesignSystem.Typography.displayMedium)
                            .foregroundColor(DesignSystem.Colors.text)

                        Text("Join Caarxd today")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }

                    // Form
                    VStack(spacing: DesignSystem.Spacing.md) {
                        TextField("First Name", text: $firstName)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()

                        TextField("Last Name", text: $lastName)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()

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

                        TextField("Phone", text: $phone)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                            .keyboardType(.phonePad)

                        SecureField("Password", text: $password)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )

                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    // Sign Up Button
                    Button(action: handleSignUp) {
                        Text("Create Account")
                            .primaryButton()
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.5)
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    Spacer()
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Sign Up Failed", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }

    private func handleSignUp() {
        let authState = AuthState.shared

        Task {
            let success = await authState.signUp(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                phone: phone
            )

            if success {
                // Create User profile in SwiftData (for local caching)
                let user = User(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phone: phone
                )
                modelContext.insert(user)

                authState.markWelcomeSlidesAsSeen()
                dismiss()
            } else {
                errorMessage = authState.errorMessage ?? "An account with this email already exists."
                showingError = true
            }
        }
    }
}

#Preview {
    SignUpView()
}
