//
//  HomeView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var businessCards: [BusinessCard]
    @Query private var analytics: [AnalyticsEvent]

    @State private var selectedCard: BusinessCard?
    @State private var selectedPeriod: TimePeriod = .week
    @State private var showingCardSelector = false
    @State private var showingShareSheet = false
    @State private var showingEditCard = false
    @State private var showingNoCardsAlert = false
    @State private var showingSettings = false
    @State private var showingThemes = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // Header Section
                    headerSection

                    // Card Selector
                    cardSelectorSection

                    // Quick Actions
                    quickActionsSection

                    // Metrics
                    metricsSection

                    // Analytics Chart
                    analyticsSection
                }
                .padding(DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: { showingSettings = true }) {
                            Label("Settings", systemImage: "gear")
                        }
                        Button(action: { showingThemes = true }) {
                            Label("Themes", systemImage: "circle.lefthalf.filled")
                        }
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.title3)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Time Period", selection: $selectedPeriod) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                    } label: {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                }
            }
        }
        .onAppear {
            if selectedCard == nil, let firstCard = businessCards.first {
                selectedCard = firstCard
            }
        }
        .onChange(of: businessCards) { oldCards, newCards in
            if let selected = selectedCard, !newCards.contains(where: { $0.id == selected.id }) {
                selectedCard = newCards.first
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let card = selectedCard {
                ShareSheet(card: card)
            }
        }
        .sheet(isPresented: $showingEditCard) {
            if let card = selectedCard {
                EditBusinessCardView(card: card)
            }
        }
        .sheet(isPresented: $showingSettings) {
            UserProfileView()
        }
        .sheet(isPresented: $showingThemes) {
            ThemeSettingsView()
        }
        .alert("No Cards Added", isPresented: $showingNoCardsAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Add Card") {
                NotificationCenter.default.post(name: NSNotification.Name("NavigateToWalletAndCreate"), object: nil)
            }
        } message: {
            Text("You haven't created any business cards yet. Would you like to create one now?")
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Dashboard")
                .font(DesignSystem.Typography.displaySmall)
                .foregroundColor(DesignSystem.Colors.text)

            Text("Track your card performance")
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Card Selector
    private var cardSelectorSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Active Card")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(1)

            Button(action: { showingCardSelector.toggle() }) {
                HStack(spacing: DesignSystem.Spacing.md) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text(selectedCard?.fullName ?? "No Card Selected")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.text)

                        if let card = selectedCard {
                            Text(card.title)
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                }
                .padding(DesignSystem.Spacing.lg)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(DesignSystem.CornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .stroke(DesignSystem.Colors.border, lineWidth: 1)
                )
            }
            .confirmationDialog("Select Card", isPresented: $showingCardSelector) {
                ForEach(businessCards) { card in
                    Button(card.fullName) {
                        selectedCard = card
                    }
                }
            }
        }
    }

    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Button(action: {
                if selectedCard != nil {
                    showingShareSheet = true
                } else {
                    showingNoCardsAlert = true
                }
            }) {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                    Text("Share")
                        .font(DesignSystem.Typography.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(DesignSystem.Spacing.lg)
                .foregroundColor(DesignSystem.Colors.accent)
                .background(DesignSystem.Colors.accentSubtle)
                .cornerRadius(DesignSystem.CornerRadius.md)
            }

            Button(action: {
                if selectedCard != nil {
                    showingEditCard = true
                } else {
                    showingNoCardsAlert = true
                }
            }) {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "pencil")
                        .font(.title2)
                    Text("Edit")
                        .font(DesignSystem.Typography.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(DesignSystem.Spacing.lg)
                .foregroundColor(DesignSystem.Colors.text)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(DesignSystem.CornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .stroke(DesignSystem.Colors.border, lineWidth: 1)
                )
            }
        }
    }

    // MARK: - Metrics Section
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Overview")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(1)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSystem.Spacing.md) {
                MetricCardRedesigned(
                    value: "\(filteredAnalytics(.view).count)",
                    label: "Views",
                    icon: "eye"
                )

                MetricCardRedesigned(
                    value: "\(filteredAnalytics(.share).count)",
                    label: "Shares",
                    icon: "square.and.arrow.up"
                )

                MetricCardRedesigned(
                    value: "\(filteredAnalytics(.contactSave).count)",
                    label: "Saves",
                    icon: "person.badge.plus"
                )

                MetricCardRedesigned(
                    value: "\(filteredAnalytics(.linkClick).count)",
                    label: "Clicks",
                    icon: "link"
                )
            }
        }
    }

    // MARK: - Analytics Section
    private var analyticsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Activity")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(1)

            Chart {
                ForEach(getChartData(), id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Count", dataPoint.count)
                    )
                    .foregroundStyle(DesignSystem.Colors.accent)
                    .lineStyle(StrokeStyle(lineWidth: 2))

                    AreaMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Count", dataPoint.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.Colors.accent.opacity(0.2), DesignSystem.Colors.accent.opacity(0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0))
                    AxisTick(stroke: StrokeStyle(lineWidth: 0))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [2, 4]))
                        .foregroundStyle(DesignSystem.Colors.border)
                    AxisTick(stroke: StrokeStyle(lineWidth: 0))
                }
            }
            .padding(DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.surface)
            .cornerRadius(DesignSystem.CornerRadius.md)
        }
    }

    // MARK: - Helper Methods
    private func filteredAnalytics(_ type: EventType) -> [AnalyticsEvent] {
        let filtered = analytics.filter { event in
            guard event.eventType == type.rawValue else { return false }
            guard event.businessCardID == selectedCard?.id else { return false }

            let calendar = Calendar.current
            let now = Date()

            switch selectedPeriod {
            case .day:
                return calendar.isDate(event.timestamp, inSameDayAs: now)
            case .week:
                return event.timestamp >= calendar.date(byAdding: .day, value: -7, to: now)!
            case .month:
                return event.timestamp >= calendar.date(byAdding: .day, value: -30, to: now)!
            case .all:
                return true
            }
        }
        return filtered
    }

    private func getChartData() -> [ChartDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        var dataPoints: [ChartDataPoint] = []

        let days: Int
        switch selectedPeriod {
        case .day: days = 1
        case .week: days = 7
        case .month: days = 30
        case .all: days = 90
        }

        for i in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -i, to: now) else { continue }
            let count = analytics.filter { event in
                calendar.isDate(event.timestamp, inSameDayAs: date) &&
                event.businessCardID == selectedCard?.id
            }.count
            dataPoints.append(ChartDataPoint(date: date, count: count))
        }

        return dataPoints.reversed()
    }
}

// MARK: - Supporting Types
enum TimePeriod: String, CaseIterable {
    case day = "Today"
    case week = "This Week"
    case month = "This Month"
    case all = "All Time"
}

struct ChartDataPoint {
    let date: Date
    let count: Int
}

// MARK: - Metric Card Redesigned
struct MetricCardRedesigned: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Spacer()

            Text(value)
                .font(DesignSystem.Typography.title1)
                .foregroundColor(DesignSystem.Colors.text)

            Text(label)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .padding(DesignSystem.Spacing.lg)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.CornerRadius.md)
    }
}

#Preview {
    HomeView()
}
