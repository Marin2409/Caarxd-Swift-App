# Caarxd - Business Card Wallet App

A comprehensive digital business card management app built with SwiftUI for iOS 18+.

## Features

### Business Card Management
- Create multiple personalized business cards with custom fields
- Rich card customization (colors, logos, layouts)
- Generate branded QR codes for each card
- Apple Wallet integration (PassKit)
- Multi-channel sharing (QR code, Deep links, AirDrop, Messages, Email, Social media)

### Analytics Dashboard
- Track unique views, received contacts, cards shared, contact saves, and link clicks
- Time-based analytics (daily, weekly, monthly trends)
- Interactive charts and visualizations
- Export functionality for reports

### Smart Card Scanning
- Camera-based QR code recognition
- OCR for business card text extraction
- Barcode scanning support
- Automatic contact creation
- Self-digitization feature for personal cards

### Work Card Integration
- Store company-issued credentials
- Work ID cards, building access cards, membership cards
- Apple Wallet integration for tap-to-use functionality

## Tech Stack

- **Platform**: iOS 18+
- **Language**: Swift
- **Framework**: SwiftUI
- **Architecture**: MVVM pattern
- **Persistence**: SwiftData
- **Camera**: AVFoundation, VisionKit
- **OCR**: Vision Framework
- **Charts**: SwiftUI Charts
- **Wallet**: PassKit

## Project Structure

```
Caarxd/
├── App/
│   └── CaarxdApp.swift              # Main app entry point
├── Models/
│   ├── BusinessCard.swift            # Business card data model
│   ├── Contact.swift                 # Contact data model
│   ├── AnalyticsEvent.swift          # Analytics tracking model
│   └── WorkCard.swift                # Work card data model
├── Views/
│   ├── MainTabView.swift             # Tab navigation
│   ├── Home/
│   │   └── HomeView.swift            # Dashboard with analytics
│   ├── Wallet/
│   │   ├── WalletView.swift          # Card management view
│   │   ├── CreateBusinessCardView.swift
│   │   ├── BusinessCardDetailView.swift
│   │   ├── CreateWorkCardView.swift
│   │   └── WorkCardDetailView.swift
│   ├── Scan/
│   │   └── ScanView.swift            # Camera & QR scanning
│   └── Contacts/
│       ├── ContactsView.swift        # Contact list with search
│       └── ContactDetailView.swift   # Contact details
├── Services/
│   ├── QRCodeService.swift           # QR code generation
│   ├── SharingService.swift          # Share functionality
│   ├── AnalyticsService.swift        # Analytics tracking
│   └── PassKitService.swift          # Apple Wallet integration
└── Resources/
    └── Assets.xcassets               # App assets
```

## Setup Instructions

### 1. Required Permissions

Add these privacy descriptions to your app's configuration (in Xcode: Target > Info):

- **NSCameraUsageDescription**: "We need camera access to scan business cards and QR codes"
- **NSPhotoLibraryUsageDescription**: "We need photo library access to save and select card images"
- **NSContactsUsageDescription**: "We need contacts access to sync your business contacts"

### 2. Configure in Xcode

1. Open `Caarxd.xcodeproj` in Xcode
2. Select the Caarxd target
3. Go to "Signing & Capabilities"
4. Add your development team
5. Add the following capabilities:
   - Contacts
   - Wallet (for PassKit integration)

### 3. PassKit Configuration (Optional)

To enable Apple Wallet integration:

1. Create a Pass Type ID in Apple Developer Portal
2. Generate signing certificates
3. Set up a backend server to generate and sign .pkpass files
4. Update `PassKitService.swift` with your backend endpoint

### 4. Backend Integration (Optional)

For full analytics and card sharing via deep links:

**Recommended Backend Options:**
- Firebase (Authentication, Firestore, Analytics)
- AWS Amplify
- Custom REST API

**What the backend would handle:**
- User authentication
- Card data synchronization
- Analytics aggregation and storage
- Deep link resolution
- PassKit pass generation and signing

**To integrate Firebase:**
```swift
// 1. Add Firebase SDK via Swift Package Manager
// 2. Add GoogleService-Info.plist to project
// 3. Initialize in CaarxdApp.swift:

import FirebaseCore

init() {
    FirebaseApp.configure()
    // ... existing code
}
```

### 5. Deep Linking Setup

To enable card sharing via deep links:

1. Add Associated Domains capability in Xcode
2. Create an apple-app-site-association file on your domain
3. Update URL scheme in Info:
   - URL Types > Add > Identifier: `com.yourcompany.caarxd`
   - URL Schemes: `caarxd`

## Building and Running

1. Open the project in Xcode 16.1.1+
2. Select your target device or simulator (iOS 18+)
3. Build and run (Cmd+R)

## Usage

### Creating a Business Card

1. Tap the Wallet tab
2. Tap the + button
3. Select "New Business Card"
4. Fill in your information
5. Customize colors and add a logo
6. Tap Save

### Scanning a Business Card

1. Tap the Scan tab
2. Select scan mode (QR Code, Business Card, or Barcode)
3. Tap "Start Scanning"
4. Point camera at the card or QR code
5. Review extracted information
6. Tap Save to add to contacts

### Viewing Analytics

1. Tap the Home tab
2. Select a business card from the dropdown
3. Choose time period (24h, 7d, 30d, All)
4. View metrics and activity trends

### Managing Contacts

1. Tap the Contacts tab
2. Search or filter contacts
3. Tap a contact to view details
4. Swipe left to delete
5. Swipe right to favorite

## Features Coming Soon

- [ ] Advanced OCR for business card text extraction
- [ ] Custom link lists (Linktree-style)
- [ ] Geographic analytics (with location permissions)
- [ ] Export analytics reports
- [ ] Batch contact operations
- [ ] Custom card templates
- [ ] NFC support for contactless sharing
- [ ] iCloud sync across devices
- [ ] Multiple language support

## Notes

### Current Limitations

1. **PassKit Integration**: Requires backend server setup to generate signed passes
2. **OCR Processing**: Basic implementation included, can be enhanced with ML Kit or Azure Computer Vision
3. **Analytics Backend**: Currently uses local SwiftData storage; implement backend for cross-device sync
4. **Deep Links**: Require domain association and backend to resolve card IDs

### Development Tips

- All SwiftData models are in the `Models/` directory
- Services are stateless and use singleton pattern
- Views follow MVVM architecture
- Use `AnalyticsService` to track events throughout the app
- QR codes are generated using CoreImage filters

## Contributing

This is a proprietary project. For questions or issues, contact the development team.

## License

All rights reserved. Copyright 2025 Jose Marin.
