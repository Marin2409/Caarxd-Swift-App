//
//  BusinessCardDetailView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct BusinessCardDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let card: BusinessCard

    @State private var showingShareSheet = false
    @State private var showingEditView = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Card Preview
                BusinessCardPreview(card: card)
                    .padding()

                // QR Code
                if let qrCodeData = card.qrCodeData, let uiImage = UIImage(data: qrCodeData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                }

                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: { showingShareSheet = true }) {
                        Label("Share Card", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: { addToWallet() }) {
                        Label(card.isInWallet ? "In Wallet" : "Add to Wallet", systemImage: "wallet.pass")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(card.isInWallet ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(card.isInWallet)

                    Button(action: { showingEditView = true }) {
                        Label("Edit Card", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray5))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                }
                .padding()

                // Card Details
                VStack(alignment: .leading, spacing: 16) {
                    if !card.email.isEmpty {
                        InfoRow(icon: "envelope.fill", text: card.email)
                    }
                    if !card.phone.isEmpty {
                        InfoRow(icon: "phone.fill", text: card.phone)
                    }
                    if !card.website.isEmpty {
                        InfoRow(icon: "globe", text: card.website)
                    }
                    if !card.linkedInURL.isEmpty {
                        InfoRow(icon: "link", text: "LinkedIn Profile")
                    }
                }
                .padding()
            }
        }
        .navigationTitle(card.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addToWallet() {
        card.isInWallet = true
        card.walletPassID = UUID().uuidString
    }
}

struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
                .font(.body)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        BusinessCardDetailView(card: BusinessCard(
            firstName: "John",
            lastName: "Doe",
            title: "iOS Developer",
            company: "Tech Corp",
            email: "john@techcorp.com"
        ))
    }
}
