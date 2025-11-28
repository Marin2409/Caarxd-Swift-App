//
//  HomeView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import Charts

enum TimePeriod: String, CaseIterable {
    case day = "24h"
    case week = "7d"
    case month = "30d"
    case all = "All"
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var businessCards: [BusinessCard]
    @Query private var analytics: [AnalyticsEvent]

    @State private var selectedCard: BusinessCard?
    @State private var selectedPeriod: TimePeriod = .week
    @State private var showingCardSelector = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Card Selector
                    cardSelectorSection

                    // Quick Actions
                    quickActionsSection

                    // Metrics Grid
                    metricsGridSection

                    // Analytics Charts
                    analyticsChartsSection
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Time Period", selection: $selectedPeriod) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
        .onAppear {
            if selectedCard == nil, let firstCard = businessCards.first {
                selectedCard = firstCard
            }
        }
    }

    // MARK: - Card Selector Section
    private var cardSelectorSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Selected Card")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button(action: { showingCardSelector.toggle() }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(selectedCard?.fullName ?? "No Card Selected")
                            .font(.headline)
                        if let card = selectedCard {
                            Text(card.title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)
            }
            .foregroundColor(.primary)
            .confirmationDialog("Select Card", isPresented: $showingCardSelector) {
                ForEach(businessCards) { card in
                    Button(card.fullName) {
                        selectedCard = card
                    }
                }
            }
        }
    }

    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button(action: {}) {
                Label("Edit", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }

    // MARK: - Metrics Grid Section
    private var metricsGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            MetricCard(
                title: "Views",
                value: "\(filteredAnalytics(.view).count)",
                icon: "eye.fill",
                color: .blue
            )

            MetricCard(
                title: "Shares",
                value: "\(filteredAnalytics(.share).count)",
                icon: "square.and.arrow.up.fill",
                color: .green
            )

            MetricCard(
                title: "Contacts",
                value: "\(filteredAnalytics(.contactSave).count)",
                icon: "person.fill.badge.plus",
                color: .orange
            )

            MetricCard(
                title: "Link Clicks",
                value: "\(filteredAnalytics(.linkClick).count)",
                icon: "link",
                color: .purple
            )
        }
    }

    // MARK: - Analytics Charts Section
    private var analyticsChartsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Trend")
                .font(.headline)

            Chart {
                ForEach(getChartData(), id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Count", dataPoint.count)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 200)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5)
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

// MARK: - Supporting Views
struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

struct ChartDataPoint {
    let date: Date
    let count: Int
}

#Preview {
    HomeView()
}
