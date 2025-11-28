//
//  EditProfileView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let user: User?

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var profileImageData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            if let imageData = profileImageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.blue)
                                    )
                            }

                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                Text("Change Photo")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        Spacer()
                    }
                }

                Section("Personal Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section("Contact Information") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle(user == nil ? "Create Profile" : "Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        profileImageData = data
                    }
                }
            }
            .onAppear {
                loadUserData()
            }
        }
    }

    private func loadUserData() {
        if let user = user {
            firstName = user.firstName
            lastName = user.lastName
            email = user.email
            phone = user.phone
            profileImageData = user.profileImageData
        }
    }

    private func saveProfile() {
        if let existingUser = user {
            // Update existing user
            existingUser.firstName = firstName
            existingUser.lastName = lastName
            existingUser.email = email
            existingUser.phone = phone
            existingUser.profileImageData = profileImageData
            existingUser.updatedAt = Date()
        } else {
            // Create new user
            let newUser = User(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone
            )
            newUser.profileImageData = profileImageData
            modelContext.insert(newUser)
        }

        dismiss()
    }
}

#Preview {
    EditProfileView(user: nil)
}
