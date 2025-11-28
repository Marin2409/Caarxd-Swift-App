//
//  WorkCardDetailView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct WorkCardDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let card: WorkCard

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Card Image
                if let imageData = card.cardImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .padding()
                }

                // Action Button
                Button(action: { addToWallet() }) {
                    Label(card.isInWallet ? "In Wallet" : "Add to Wallet", systemImage: "wallet.pass")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(card.isInWallet ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(card.isInWallet)
                .padding(.horizontal)

                // Card Details
                VStack(alignment: .leading, spacing: 16) {
                    InfoRow(icon: "building.2", text: card.company)
                    InfoRow(icon: "person", text: card.employeeName)
                    InfoRow(icon: "number", text: card.employeeID)
                }
                .padding()
            }
        }
        .navigationTitle(card.cardName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addToWallet() {
        card.isInWallet = true
        card.walletPassID = UUID().uuidString
    }
}

#Preview {
    NavigationStack {
        WorkCardDetailView(card: WorkCard(
            cardName: "Tesla Employee ID",
            cardType: .employeeID,
            company: "Tesla",
            employeeName: "John Doe",
            employeeID: "EMP12345"
        ))
    }
}
