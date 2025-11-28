//
//  CardCreationOnboardingView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CardCreationOnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var title = ""
    @State private var company = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var website = ""
    @State private var primaryColor = Color.blue
    @State private var selectedLogoItem: PhotosPickerItem?
    @State private var logoData: Data?

    let totalSteps = 4

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                    .tint(DesignSystem.Colors.accent)
                    .padding(DesignSystem.Spacing.lg)

                // Step Content
                TabView(selection: $currentStep) {
                    // Step 1: Name
                    stepView(
                        step: 0,
                        title: "Let's start with your name",
                        icon: "person.fill",
                        content: AnyView(
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

                                TextField("Last Name", text: $lastName)
                                    .padding(DesignSystem.Spacing.md)
                                    .background(DesignSystem.Colors.surface)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                    )
                                    .textInputAutocapitalization(.words)
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        )
                    )

                    // Step 2: Professional Info
                    stepView(
                        step: 1,
                        title: "Your professional details",
                        icon: "briefcase.fill",
                        content: AnyView(
                            VStack(spacing: DesignSystem.Spacing.md) {
                                TextField("Job Title", text: $title)
                                    .padding(DesignSystem.Spacing.md)
                                    .background(DesignSystem.Colors.surface)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                    )
                                    .textInputAutocapitalization(.words)

                                TextField("Company", text: $company)
                                    .padding(DesignSystem.Spacing.md)
                                    .background(DesignSystem.Colors.surface)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                    )
                                    .textInputAutocapitalization(.words)
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        )
                    )

                    // Step 3: Contact Info
                    stepView(
                        step: 2,
                        title: "How can people reach you?",
                        icon: "envelope.fill",
                        content: AnyView(
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

                                TextField("Phone", text: $phone)
                                    .padding(DesignSystem.Spacing.md)
                                    .background(DesignSystem.Colors.surface)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                    )
                                    .keyboardType(.phonePad)

                                TextField("Website (optional)", text: $website)
                                    .padding(DesignSystem.Spacing.md)
                                    .background(DesignSystem.Colors.surface)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                    )
                                    .keyboardType(.URL)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        )
                    )

                    // Step 4: Customization
                    stepView(
                        step: 3,
                        title: "Make it yours",
                        icon: "paintpalette.fill",
                        content: AnyView(
                            VStack(spacing: DesignSystem.Spacing.md) {
                                HStack {
                                    Text("Card Color")
                                        .font(DesignSystem.Typography.body)
                                        .foregroundColor(DesignSystem.Colors.text)

                                    Spacer()

                                    ColorPicker("", selection: $primaryColor)
                                        .labelsHidden()
                                }
                                .padding(DesignSystem.Spacing.md)
                                .background(DesignSystem.Colors.surface)
                                .cornerRadius(DesignSystem.CornerRadius.md)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                        .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                )

                                PhotosPicker(selection: $selectedLogoItem, matching: .images) {
                                    HStack {
                                        Text("Company Logo (optional)")
                                            .font(DesignSystem.Typography.body)
                                            .foregroundColor(DesignSystem.Colors.text)

                                        Spacer()

                                        if let logoData, let uiImage = UIImage(data: logoData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 32, height: 32)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "photo")
                                                .font(.title3)
                                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                        }
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
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        )
                    )
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Navigation Buttons
                HStack(spacing: DesignSystem.Spacing.md) {
                    if currentStep > 0 {
                        Button(action: { currentStep -= 1 }) {
                            Text("Back")
                                .secondaryButton()
                        }
                    }

                    Button(action: handleNext) {
                        Text(currentStep == totalSteps - 1 ? "Create Card" : "Next")
                            .primaryButton()
                    }
                    .disabled(!canProceed)
                    .opacity(canProceed ? 1.0 : 0.5)
                }
                .padding(DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Create Your First Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") {
                        AuthState.shared.completeOnboarding()
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedLogoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        logoData = data
                    }
                }
            }
        }
    }

    private func stepView(step: Int, title: String, icon: String, content: AnyView) -> some View {
        VStack(spacing: DesignSystem.Spacing.xxxl) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(DesignSystem.Colors.accent)
                .padding(.top, DesignSystem.Spacing.xxxl)

            Text(title)
                .font(DesignSystem.Typography.title1)
                .foregroundColor(DesignSystem.Colors.text)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.Spacing.lg)

            content

            Spacer()
        }
        .tag(step)
    }

    private var canProceed: Bool {
        switch currentStep {
        case 0: return !firstName.isEmpty && !lastName.isEmpty
        case 1: return !title.isEmpty && !company.isEmpty
        case 2: return !email.isEmpty && !phone.isEmpty
        case 3: return true // Customization is optional
        default: return false
        }
    }

    private func handleNext() {
        if currentStep < totalSteps - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            createCard()
        }
    }

    private func createCard() {
        let card = BusinessCard(
            firstName: firstName,
            lastName: lastName,
            title: title,
            company: company,
            email: email,
            phone: phone,
            website: website,
            primaryColor: primaryColor.toHex() ?? "#007AFF"
        )
        card.logoData = logoData

        // Generate QR code
        if let qrData = QRCodeService.shared.generateQRCode(from: card) {
            card.qrCodeData = qrData
        }

        modelContext.insert(card)

        // Track card creation
        let event = AnalyticsEvent(
            eventType: .cardCreated,
            businessCardID: card.id,
            metadata: ["cardName": card.fullName, "onboarding": "true"]
        )
        modelContext.insert(event)

        AuthState.shared.completeOnboarding()
        dismiss()
    }
}

#Preview {
    CardCreationOnboardingView()
}
