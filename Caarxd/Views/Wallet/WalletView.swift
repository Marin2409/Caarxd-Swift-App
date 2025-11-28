//
//  WalletView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct WalletView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var businessCards: [BusinessCard]
    @Query private var workCards: [WorkCard]

    @State private var showingCreateCard = false
    @State private var showingAddWorkCard = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Personal Business Cards Section
                    personalCardsSection

                    Divider()
                        .padding(.vertical)

                    // Work Cards Section
                    workCardsSection
                }
                .padding()
            }
            .navigationTitle("Wallet")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingCreateCard = true }) {
                            Label("New Business Card", systemImage: "person.crop.rectangle")
                        }
                        Button(action: { showingAddWorkCard = true }) {
                            Label("Add Work Card", systemImage: "briefcase")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateCard) {
                CreateBusinessCardView()
            }
            .sheet(isPresented: $showingAddWorkCard) {
                CreateWorkCardView()
            }
        }
    }

    // MARK: - Personal Cards Section
    private var personalCardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Personal Cards")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("\(businessCards.count)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            if businessCards.isEmpty {
                emptyStateView(
                    icon: "person.crop.rectangle",
                    title: "No Business Cards",
                    message: "Create your first digital business card",
                    action: { showingCreateCard = true }
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(businessCards) { card in
                            NavigationLink(destination: BusinessCardDetailView(card: card)) {
                                BusinessCardPreview(card: card)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Work Cards Section
    private var workCardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Work Cards")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("\(workCards.count)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            if workCards.isEmpty {
                emptyStateView(
                    icon: "briefcase",
                    title: "No Work Cards",
                    message: "Add your employee ID or access cards",
                    action: { showingAddWorkCard = true }
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(workCards) { card in
                        NavigationLink(destination: WorkCardDetailView(card: card)) {
                            WorkCardRow(card: card)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Empty State View
    private func emptyStateView(icon: String, title: String, message: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button(action: action) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Business Card Preview
struct BusinessCardPreview: View {
    let card: BusinessCard

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Card Header
            HStack {
                if let logoData = card.logoData, let uiImage = UIImage(data: logoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color(hex: card.primaryColor) ?? .blue)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(card.firstName.prefix(1))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                }
                Spacer()
                if card.isInWallet {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }

            Spacer()

            // Card Content
            VStack(alignment: .leading, spacing: 4) {
                Text(card.fullName)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(card.title)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                Text(card.company)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .frame(width: 280, height: 180)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: card.primaryColor) ?? .blue,
                    Color(hex: card.secondaryColor) ?? .purple
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

// MARK: - Work Card Row
struct WorkCardRow: View {
    let card: WorkCard

    var body: some View {
        HStack(spacing: 16) {
            if let imageData = card.cardImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "briefcase")
                            .foregroundColor(.blue)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(card.cardName)
                    .font(.headline)
                Text(card.company)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if card.isInWallet {
                Image(systemName: "wallet.pass.fill")
                    .foregroundColor(.green)
            }

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

// MARK: - Color Extension
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    WalletView()
}
