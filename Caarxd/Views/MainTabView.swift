//
//  MainTabView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var shouldShowCreateCard = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "chart.bar.fill")
                }
                .tag(0)
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToWalletAndCreate"))) { _ in
                    selectedTab = 1
                    // Delay slightly to ensure tab switch completes first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        shouldShowCreateCard = true
                    }
                }

            WalletView(shouldShowCreateCard: $shouldShowCreateCard)
                .tabItem {
                    Label("Wallet", systemImage: "wallet.pass.fill")
                }
                .tag(1)

            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
                .tag(2)

            ContactsView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
}
