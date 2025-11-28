//
//  CreateBusinessCardView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateBusinessCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

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
            .navigationTitle("New Business Card")
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
        }
    }

    private func saveCard() {
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
        card.linkedInURL = linkedInURL
        card.logoData = logoData

        modelContext.insert(card)
        dismiss()
    }
}

// MARK: - Color to Hex Extension
extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}

#Preview {
    CreateBusinessCardView()
}
