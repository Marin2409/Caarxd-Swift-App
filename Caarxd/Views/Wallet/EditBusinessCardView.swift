//
//  EditBusinessCardView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditBusinessCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let card: BusinessCard

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var title = ""
    @State private var company = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var website = ""
    @State private var linkedInURL = ""
    @State private var primaryColor = Color.blue
    @State private var selectedLogoItem: PhotosPickerItem?
    @State private var logoData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Job Title", text: $title)
                    TextField("Company", text: $company)
                }

                Section("Contact Information") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Website", text: $website)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }

                Section("Social Media") {
                    TextField("LinkedIn URL", text: $linkedInURL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }

                Section("Customization") {
                    ColorPicker("Primary Color", selection: $primaryColor)

                    PhotosPicker(selection: $selectedLogoItem, matching: .images) {
                        HStack {
                            Text("Company Logo")
                            Spacer()
                            if let logoData, let uiImage = UIImage(data: logoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "photo")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Business Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCard()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty)
                }
            }
            .onChange(of: selectedLogoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        logoData = data
                    }
                }
            }
            .onAppear {
                loadCardData()
            }
        }
    }

    private func loadCardData() {
        firstName = card.firstName
        lastName = card.lastName
        title = card.title
        company = card.company
        email = card.email
        phone = card.phone
        website = card.website
        linkedInURL = card.linkedInURL
        logoData = card.logoData

        if let hexColor = Color(hex: card.primaryColor) {
            primaryColor = hexColor
        }
    }

    private func saveCard() {
        card.firstName = firstName
        card.lastName = lastName
        card.title = title
        card.company = company
        card.email = email
        card.phone = phone
        card.website = website
        card.linkedInURL = linkedInURL
        card.primaryColor = primaryColor.toHex() ?? "#007AFF"
        card.logoData = logoData
        card.updatedAt = Date()

        // Regenerate QR code with updated information
        if let qrData = QRCodeService.shared.generateQRCode(from: card) {
            card.qrCodeData = qrData
        }

        // Track card edit event
        let event = AnalyticsEvent(
            eventType: .cardEdited,
            businessCardID: card.id,
            metadata: ["cardName": card.fullName]
        )
        modelContext.insert(event)

        dismiss()
    }
}

#Preview {
    EditBusinessCardView(card: BusinessCard(
        firstName: "John",
        lastName: "Doe",
        title: "iOS Developer",
        company: "Tech Corp",
        email: "john@techcorp.com"
    ))
}
