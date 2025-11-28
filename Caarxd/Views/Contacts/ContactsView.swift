//
//  ContactsView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct ContactsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Contact.firstName) private var contacts: [Contact]

    @State private var searchText = ""
    @State private var showingFilterOptions = false
    @State private var filterByFavorites = false
    @State private var selectedTag: String?

    var filteredContacts: [Contact] {
        var result = contacts

        if filterByFavorites {
            result = result.filter { $0.isFavorite }
        }

        if let tag = selectedTag {
            result = result.filter { $0.tags.contains(tag) }
        }

        if !searchText.isEmpty {
            result = result.filter { contact in
                contact.fullName.localizedCaseInsensitiveContains(searchText) ||
                contact.company.localizedCaseInsensitiveContains(searchText) ||
                contact.email.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    var availableTags: [String] {
        let allTags = contacts.flatMap { $0.tags }
        return Array(Set(allTags)).sorted()
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter Bar
                if filterByFavorites || selectedTag != nil {
                    filterBar
                }

                // Contacts List
                if filteredContacts.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(groupedContacts.keys.sorted(), id: \.self) { letter in
                            Section(header: Text(letter)) {
                                ForEach(groupedContacts[letter] ?? []) { contact in
                                    NavigationLink(destination: ContactDetailView(contact: contact)) {
                                        ContactRow(contact: contact)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button(action: { toggleFavorite(contact) }) {
                                            Label("Favorite", systemImage: contact.isFavorite ? "star.slash" : "star.fill")
                                        }
                                        .tint(.yellow)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive, action: { deleteContact(contact) }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Contacts")
            .searchable(text: $searchText, prompt: "Search contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { filterByFavorites.toggle() }) {
                            Label("Favorites Only", systemImage: filterByFavorites ? "checkmark" : "star")
                        }

                        if !availableTags.isEmpty {
                            Menu("Filter by Tag") {
                                Button("All Tags") {
                                    selectedTag = nil
                                }
                                ForEach(availableTags, id: \.self) { tag in
                                    Button(tag) {
                                        selectedTag = tag
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }

    // MARK: - Filter Bar
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if filterByFavorites {
                    FilterChip(title: "Favorites", onRemove: {
                        filterByFavorites = false
                    })
                }
                if let tag = selectedTag {
                    FilterChip(title: tag, onRemove: {
                        selectedTag = nil
                    })
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("No Contacts")
                .font(.headline)
            Text(searchText.isEmpty ? "Scan a business card to add your first contact" : "No contacts match your search")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Grouped Contacts
    private var groupedContacts: [String: [Contact]] {
        Dictionary(grouping: filteredContacts) { contact in
            let firstLetter = contact.firstName.prefix(1).uppercased()
            return firstLetter.isEmpty ? "#" : firstLetter
        }
    }

    // MARK: - Actions
    private func toggleFavorite(_ contact: Contact) {
        contact.isFavorite.toggle()
    }

    private func deleteContact(_ contact: Contact) {
        modelContext.delete(contact)
    }
}

// MARK: - Contact Row
struct ContactRow: View {
    let contact: Contact

    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            if let imageData = contact.cardImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(contact.firstName.prefix(1))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    )
            }

            // Contact Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(contact.fullName)
                        .font(.headline)
                    if contact.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
                if !contact.company.isEmpty {
                    Text(contact.company)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !contact.title.isEmpty {
                    Text(contact.title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Sync Status
            if contact.syncedToContacts {
                Image(systemName: "checkmark.icloud.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.subheadline)
            Button(action: onRemove) {
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

#Preview {
    ContactsView()
}
