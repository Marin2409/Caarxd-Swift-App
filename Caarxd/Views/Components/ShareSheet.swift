//
//  ShareSheet.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct ShareSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let card: BusinessCard

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // Card Preview
                    BusinessCardPreview(card: card)
                        .padding(DesignSystem.Spacing.lg)

                    // QR Code
                    if let qrCodeData = card.qrCodeData, let uiImage = UIImage(data: qrCodeData) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            Text("Scan to View")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.text)

                            Image(uiImage: uiImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .padding(DesignSystem.Spacing.lg)
                                .background(DesignSystem.Colors.surface)
                                .cornerRadius(DesignSystem.CornerRadius.lg)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                        .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                )
                        }
                    }

                    // Share URL
                    VStack(spacing: DesignSystem.Spacing.md) {
                        Text("Share Link")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.text)

                        HStack {
                            Text(card.shareURL)
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                .lineLimit(1)
                                .truncationMode(.middle)

                            Button(action: copyToClipboard) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(DesignSystem.Colors.accent)
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
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    // Share Button
                    Button(action: shareCard) {
                        Text("Share Card")
                            .primaryButton()
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                    Spacer()
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Share Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func copyToClipboard() {
        UIPasteboard.general.string = card.shareURL

        // Track copy event
        let event = AnalyticsEvent(
            eventType: .share,
            businessCardID: card.id,
            metadata: ["method": "copy_link"]
        )
        modelContext.insert(event)
    }

    private func shareCard() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return
        }

        var itemsToShare: [Any] = [card.shareURL]

        if let qrCodeData = card.qrCodeData, let qrImage = UIImage(data: qrCodeData) {
            itemsToShare.append(qrImage)
        }

        let activityVC = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )

        // Track share event
        let event = AnalyticsEvent(
            eventType: .share,
            businessCardID: card.id,
            metadata: ["method": "native_share"]
        )
        modelContext.insert(event)

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = window
            popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        rootVC.present(activityVC, animated: true)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BusinessCard.self, configurations: config)

    let card = BusinessCard(
        firstName: "John",
        lastName: "Doe",
        title: "Software Engineer",
        company: "Tech Co",
        email: "john@example.com",
        phone: "555-0100",
        website: "example.com",
        primaryColor: "#007AFF"
    )

    return ShareSheet(card: card)
        .modelContainer(container)
}
