//
//  FirebaseConfig.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics

class FirebaseConfig {
    static let shared = FirebaseConfig()

    private init() {}

    func configure() {
        FirebaseApp.configure()

        // Enable Firestore offline persistence
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
    }
}
