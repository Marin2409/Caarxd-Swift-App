//
//  MainTabView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "chart.bar.fill")
                }
                .tag(0)

            WalletView()
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
