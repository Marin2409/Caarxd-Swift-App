//
//  WalletViewRedesigned.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData

struct WalletView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var businessCards: [BusinessCard]
    @Query(sort: \AnalyticsEvent.timestamp, order: .reverse) private var analytics: [AnalyticsEvent]

    @Binding var shouldShowCreateCard: Bool
    @State private var showingCreateCard = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // Header
                    headerSection

                    // Cards Grid
                    cardsGridSection

                    // Recent Activity
                    recentActivitySection
                }
                .padding(DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateCard = true }) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(DesignSystem.Colors.accent)
                    }
                }
            }
            .sheet(isPresented: $showingCreateCard) {
                CreateBusinessCardView()
            }
            .onChange(of: shouldShowCreateCard) { _, newValue in
                if newValue {
                    showingCreateCard = true
                    shouldShowCreateCard = false
                }
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Wallet")
                .font(DesignSystem.Typography.displaySmall)
                .foregroundColor(DesignSystem.Colors.text)

            Text("\(businessCards.count) card\(businessCards.count == 1 ? "" : "s")")
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Cards Grid
    private var cardsGridSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Your Cards")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(1)

            if businessCards.isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSystem.Spacing.md) {
                    ForEach(businessCards) { card in
                        NavigationLink(destination: BusinessCardDetailView(card: card)) {
                            MinimalCardPreview(card: card)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteBusinessCard(card)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Recent Activity
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Recent Activity")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(1)

            if analytics.isEmpty {
                emptyActivityView
            } else {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(analytics.prefix(5)) { event in
                        MinimalActivityRow(event: event, businessCards: businessCards)
                    }
                }
            }
        }
    }

    // MARK: - Empty States
    private var emptyStateView: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Image(systemName: "rectangle.stack")
                .font(.system(size: 48))
                .foregroundColor(DesignSystem.Colors.textTertiary)

            VStack(spacing: DesignSystem.Spacing.xs) {
                Text("No Cards Yet")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.text)

                Text("Create your first digital card")
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }

            Button(action: { showingCreateCard = true }) {
                Text("Create Card")
                    .primaryButton()
            }
            .padding(.horizontal, DesignSystem.Spacing.xl)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xxxl)
    }

    private var emptyActivityView: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: "chart.line.flattrend.xyaxis")
                .font(.system(size: 32))
                .foregroundColor(DesignSystem.Colors.textTertiary)

            Text("No activity yet")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xl)
    }

    // MARK: - Helper
    private func deleteBusinessCard(_ card: BusinessCard) {
        let event = AnalyticsEvent(
            eventType: .cardDeleted,
            businessCardID: card.id,
            metadata: ["cardName": card.fullName]
        )
        modelContext.insert(event)

        withAnimation {
            modelContext.delete(card)
        }
    }
}

// MARK: - Minimal Card Preview
struct MinimalCardPreview: View {
    let card: BusinessCard

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            // Header with Logo
            HStack(alignment: .top, spacing: DesignSystem.Spacing.xs) {
                if let logoData = card.logoData, let uiImage = UIImage(data: logoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(card.firstName.prefix(1))
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        )
                }

                Spacer()

                if card.isInWallet {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }

            Spacer()

            // Name and Title
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(card.fullName)
                    .font(DesignSystem.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(card.title)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(.white)
                    .lineLimit(1)

                if !card.company.isEmpty {
                    Text(card.company)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
            }
        }
        .frame(height: 180)
        .padding(DesignSystem.Spacing.md)
        .background(
            Color(hex: card.primaryColor) ?? DesignSystem.Colors.accent
        )
        .cornerRadius(DesignSystem.CornerRadius.lg)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Minimal Activity Row
struct MinimalActivityRow: View {
    let event: AnalyticsEvent
    let businessCards: [BusinessCard]

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            // Icon
            Image(systemName: eventIcon)
                .font(.body)
                .foregroundColor(eventColor)
                .frame(width: 24)

            // Info
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(eventTitle)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.text)

                if let card = businessCards.first(where: { $0.id == event.businessCardID }) {
                    Text(card.fullName)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                }
            }

            Spacer()

            // Time
            Text(timeAgo)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textTertiary)
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.CornerRadius.sm)
    }

    private var eventIcon: String {
        switch event.eventType {
        case "view": return "eye"
        case "share": return "square.and.arrow.up"
        case "contactSave": return "person.badge.plus"
        case "linkClick": return "link"
        case "card_created": return "plus.circle"
        case "card_deleted": return "trash"
        case "card_edited": return "pencil"
        default: return "circle"
        }
    }

    private var eventColor: Color {
        switch event.eventType {
        case "card_created": return DesignSystem.Colors.success
        case "card_deleted": return DesignSystem.Colors.error
        case "share": return DesignSystem.Colors.accent
        default: return DesignSystem.Colors.textSecondary
        }
    }

    private var eventTitle: String {
        switch event.eventType {
        case "view": return "Viewed"
        case "share": return "Shared"
        case "contactSave": return "Contact Saved"
        case "linkClick": return "Link Clicked"
        case "card_created": return "Card Created"
        case "card_deleted": return "Card Deleted"
        case "card_edited": return "Card Edited"
        default: return "Activity"
        }
    }

    private var timeAgo: String {
        let seconds = Date().timeIntervalSince(event.timestamp)
        if seconds < 60 { return "Now" }
        else if seconds < 3600 { return "\(Int(seconds / 60))m" }
        else if seconds < 86400 { return "\(Int(seconds / 3600))h" }
        else { return "\(Int(seconds / 86400))d" }
    }
}

#Preview {
    WalletView(shouldShowCreateCard: .constant(false))
}
