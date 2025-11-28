//
//  ContactDetailView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import Contacts

struct ContactDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let contact: Contact

    @State private var showingEditView = false
    @State private var showingAddTags = false
    @State private var newTag = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with Avatar
                headerSection

                // Action Buttons
                actionButtonsSection

                // Contact Information
                contactInfoSection

                // Notes Section
                notesSection

                // Tags Section
                tagsSection

                // Sync Information
                syncInfoSection
            }
            .padding()
        }
        .navigationTitle(contact.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingEditView = true }) {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditContactView(contact: contact)
        }
        .sheet(isPresented: $showingAddTags) {
            NavigationStack {
                Form {
                    TextField("Tag Name", text: $newTag)
                }
                .navigationTitle("Add Tag")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddTags = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addTag()
                        }
                        .disabled(newTag.isEmpty)
                    }
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            if let imageData = contact.cardImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text(contact.firstName.prefix(1))
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    )
            }

            VStack(spacing: 4) {
                Text(contact.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                if !contact.title.isEmpty {
                    Text(contact.title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !contact.company.isEmpty {
                    Text(contact.company)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: - Action Buttons
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            if !contact.email.isEmpty {
                ActionButton(icon: "envelope.fill", title: "Email", color: .blue) {
                    openEmail()
                }
            }
            if !contact.phone.isEmpty {
                ActionButton(icon: "phone.fill", title: "Call", color: .green) {
                    openPhone()
                }
            }
            if !contact.website.isEmpty {
                ActionButton(icon: "globe", title: "Website", color: .orange) {
                    openWebsite()
                }
            }
        }
    }

    // MARK: - Contact Info Section
    private var contactInfoSection: some View {
        VStack(spacing: 12) {
            if !contact.email.isEmpty {
                DetailInfoRow(icon: "envelope.fill", label: "Email", value: contact.email)
            }
            if !contact.phone.isEmpty {
                DetailInfoRow(icon: "phone.fill", label: "Phone", value: contact.phone)
            }
            if !contact.website.isEmpty {
                DetailInfoRow(icon: "globe", label: "Website", value: contact.website)
            }
            if !contact.address.isEmpty {
                DetailInfoRow(icon: "location.fill", label: "Address", value: contact.address)
            }
        }
    }

    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.headline)
            Text(contact.notes.isEmpty ? "No notes" : contact.notes)
                .foregroundStyle(contact.notes.isEmpty ? .secondary : .primary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }

    // MARK: - Tags Section
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tags")
                    .font(.headline)
                Spacer()
                Button(action: { showingAddTags = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }

            if contact.tags.isEmpty {
                Text("No tags")
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(contact.tags, id: \.self) { tag in
                            HStack {
                                Text(tag)
                                Button(action: { removeTag(tag) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(16)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Sync Info Section
    private var syncInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sync Information")
                .font(.headline)

            VStack(spacing: 8) {
                HStack {
                    Text("Synced to Contacts")
                    Spacer()
                    if contact.syncedToContacts {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Button("Sync Now") {
                            syncToContacts()
                        }
                    }
                }

                if let scannedAt = contact.scannedAt {
                    HStack {
                        Text("Added")
                        Spacer()
                        Text(scannedAt.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }

    // MARK: - Actions
    private func openEmail() {
        if let url = URL(string: "mailto:\(contact.email)") {
            UIApplication.shared.open(url)
        }
    }

    private func openPhone() {
        let cleanPhone = contact.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel:\(cleanPhone)") {
            UIApplication.shared.open(url)
        }
    }

    private func openWebsite() {
        var urlString = contact.website
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    private func addTag() {
        if !newTag.isEmpty && !contact.tags.contains(newTag) {
            contact.tags.append(newTag)
        }
        newTag = ""
        showingAddTags = false
    }

    private func removeTag(_ tag: String) {
        contact.tags.removeAll { $0 == tag }
    }

    private func syncToContacts() {
        contact.syncedToContacts = true
        contact.contactsAppID = UUID().uuidString
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

// MARK: - Info Row for Contact Details
struct DetailInfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Edit Contact View
struct EditContactView: View {
    @Environment(\.dismiss) private var dismiss
    let contact: Contact

    @State private var firstName: String
    @State private var lastName: String
    @State private var title: String
    @State private var company: String
    @State private var email: String
    @State private var phone: String
    @State private var website: String
    @State private var notes: String

    init(contact: Contact) {
        self.contact = contact
        _firstName = State(initialValue: contact.firstName)
        _lastName = State(initialValue: contact.lastName)
        _title = State(initialValue: contact.title)
        _company = State(initialValue: contact.company)
        _email = State(initialValue: contact.email)
        _phone = State(initialValue: contact.phone)
        _website = State(initialValue: contact.website)
        _notes = State(initialValue: contact.notes)
    }

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

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Edit Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
        }
    }

    private func saveChanges() {
        contact.firstName = firstName
        contact.lastName = lastName
        contact.title = title
        contact.company = company
        contact.email = email
        contact.phone = phone
        contact.website = website
        contact.notes = notes
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ContactDetailView(contact: Contact(
            firstName: "John",
            lastName: "Doe",
            title: "iOS Developer",
            company: "Tech Corp",
            email: "john@techcorp.com",
            phone: "+1 234 567 8900"
        ))
    }
}
