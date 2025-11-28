# Caarxd Setup Guide

## Adding Files to Xcode Project

Since all the Swift files have been created in the correct folder structure, you need to add them to your Xcode project:

### Option 1: Automatic (Recommended)
1. Close Xcode if it's open
2. Delete the existing `Caarxd.xcodeproj` file
3. Create a new Xcode project in the same directory
4. When prompted, choose "Create project from existing files"
5. All files should be automatically included

### Option 2: Manual
1. Open `Caarxd.xcodeproj` in Xcode
2. In the Project Navigator, right-click on the "Caarxd" folder
3. Select "Add Files to Caarxd..."
4. Navigate to and select these folders:
   - Models/
   - Views/
   - Services/
5. Ensure "Copy items if needed" is UNCHECKED (files are already in place)
6. Ensure "Create groups" is selected
7. Ensure your target "Caarxd" is checked
8. Click "Add"

## Required Permissions Configuration

### Step 1: Add Privacy Descriptions

1. In Xcode, select your project in the Project Navigator
2. Select the "Caarxd" target
3. Go to the "Info" tab
4. Click the "+" button to add new entries
5. Add the following keys and values:

| Key | Value |
|-----|-------|
| Privacy - Camera Usage Description | We need camera access to scan business cards and QR codes |
| Privacy - Photo Library Usage Description | We need photo library access to save and select card images |
| Privacy - Contacts Usage Description | We need contacts access to sync your business contacts |

**In the Info.plist raw format, these are:**
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan business cards and QR codes</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to save and select card images</string>
<key>NSContactsUsageDescription</key>
<string>We need contacts access to sync your business contacts</string>
```

### Step 2: Add Required Capabilities

1. Select your project in Xcode
2. Select the "Caarxd" target
3. Go to "Signing & Capabilities" tab
4. Click "+ Capability" and add:
   - **Contacts** (for syncing business contacts)
   - **Wallet** (for Apple Wallet/PassKit integration)

### Step 3: Configure Signing

1. In "Signing & Capabilities" tab
2. Check "Automatically manage signing"
3. Select your development Team
4. Xcode will create provisioning profiles automatically

## Deep Linking Setup (Optional)

### Step 1: Add URL Scheme

1. In the "Info" tab
2. Scroll to "URL Types"
3. Click "+" to add a new URL Type
4. Set:
   - Identifier: `com.yourcompany.caarxd`
   - URL Schemes: `caarxd`
   - Role: Editor

### Step 2: Add Associated Domains (for Universal Links)

1. Go to "Signing & Capabilities"
2. Click "+ Capability"
3. Add "Associated Domains"
4. Add domain: `applinks:yourdomain.com`

Note: You'll need to host an `apple-app-site-association` file on your domain.

## Building the Project

### First Build Steps

1. Clean the build folder: **Product > Clean Build Folder** (Shift+Cmd+K)
2. Build the project: **Product > Build** (Cmd+B)
3. Fix any errors if they appear (usually import or file reference issues)
4. Run on simulator or device: **Product > Run** (Cmd+R)

### Common Build Issues and Fixes

#### Issue: "Cannot find type 'BusinessCard' in scope"
**Fix:** Ensure all Model files are added to the target
1. Select the file in Project Navigator
2. In File Inspector (right panel), check the target membership

#### Issue: "Module 'VisionKit' not found"
**Fix:** This is only available on iOS 13+ and real devices/recent simulators
- Ensure deployment target is set to iOS 18.0+
- Use a simulator running iOS 18+

#### Issue: Camera not working in simulator
**Fix:** Camera features require a real device
- Test camera/scanning features on a physical iPhone
- Use mock data for testing in simulator

#### Issue: SwiftData migration errors
**Fix:** Delete the app from simulator/device and reinstall
```bash
# For simulator
xcrun simctl uninstall booted com.yourcompany.caarxd
```

## Testing the App

### Test Checklist

#### Home View
- [ ] Dashboard loads without errors
- [ ] Can select different business cards
- [ ] Analytics charts display correctly
- [ ] Time period filter works
- [ ] Metrics cards show accurate counts

#### Wallet View
- [ ] Can create new business card
- [ ] Card preview displays correctly
- [ ] Can customize colors and add logo
- [ ] Can create work card
- [ ] Cards display in scrollable list

#### Scan View
- [ ] Camera permission requested on first use
- [ ] QR code scanning works (needs real device)
- [ ] Document scanner opens for business cards
- [ ] Can manually enter contact information
- [ ] Contact saves to database

#### Contacts View
- [ ] Contacts list displays
- [ ] Search filters contacts correctly
- [ ] Can favorite/unfavorite contacts
- [ ] Can delete contacts with swipe
- [ ] Contact detail view shows all info

### Testing with Sample Data

To test the app with sample data, you can add this to `CaarxdApp.swift`:

```swift
init() {
    do {
        modelContainer = try ModelContainer(
            for: BusinessCard.self,
                 Contact.self,
                 AnalyticsEvent.self,
                 WorkCard.self
        )

        // Add sample data for testing
        #if DEBUG
        addSampleData()
        #endif
    } catch {
        fatalError("Failed to initialize ModelContainer: \(error)")
    }
}

private func addSampleData() {
    let context = modelContainer.mainContext

    // Check if data already exists
    let descriptor = FetchDescriptor<BusinessCard>()
    if let count = try? context.fetchCount(descriptor), count > 0 {
        return
    }

    // Add sample business card
    let card = BusinessCard(
        firstName: "John",
        lastName: "Doe",
        title: "iOS Developer",
        company: "Tech Corp",
        email: "john@techcorp.com",
        phone: "+1 234 567 8900",
        website: "www.techcorp.com"
    )
    context.insert(card)

    // Add sample contact
    let contact = Contact(
        firstName: "Jane",
        lastName: "Smith",
        title: "Product Manager",
        company: "StartupCo",
        email: "jane@startup.co",
        phone: "+1 234 567 8901"
    )
    context.insert(contact)

    try? context.save()
}
```

## Backend Integration Guide

### Option 1: Firebase

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com
   - Create new project
   - Add iOS app with bundle identifier

2. **Add Firebase SDK**
   ```swift
   // In Xcode: File > Add Package Dependencies
   // Add: https://github.com/firebase/firebase-ios-sdk
   ```

3. **Download and Add GoogleService-Info.plist**
   - Download from Firebase Console
   - Drag into Xcode project root
   - Ensure it's added to the Caarxd target

4. **Update CaarxdApp.swift**
   ```swift
   import FirebaseCore

   init() {
       FirebaseApp.configure()
       // ... existing ModelContainer setup
   }
   ```

5. **Enable Firestore and Analytics in Firebase Console**

### Option 2: Custom Backend

If you prefer a custom backend, you'll need to implement:

1. **User Authentication API**
   - POST `/auth/register`
   - POST `/auth/login`
   - GET `/auth/verify`

2. **Business Card APIs**
   - GET `/cards` - Get user's cards
   - POST `/cards` - Create card
   - PUT `/cards/:id` - Update card
   - DELETE `/cards/:id` - Delete card
   - GET `/cards/:id/public` - Public card view (for deep links)

3. **Analytics APIs**
   - POST `/analytics/event` - Track event
   - GET `/analytics/card/:id` - Get card analytics

4. **PassKit API**
   - POST `/wallet/pass` - Generate Apple Wallet pass

Create a `NetworkService.swift`:
```swift
class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://your-api.com"

    func syncBusinessCard(_ card: BusinessCard) async throws {
        // Implementation
    }

    func trackAnalytics(_ event: AnalyticsEvent) async throws {
        // Implementation
    }
}
```

## Production Checklist

Before releasing to App Store:

- [ ] Update bundle identifier to your actual ID
- [ ] Add proper app icon (in Assets.xcassets)
- [ ] Add launch screen
- [ ] Configure production signing certificate
- [ ] Set up App Store Connect listing
- [ ] Add privacy policy URL
- [ ] Test on multiple device sizes
- [ ] Test both light and dark mode
- [ ] Add proper error handling
- [ ] Implement crash reporting (e.g., Firebase Crashlytics)
- [ ] Add analytics (e.g., Firebase Analytics, Mixpanel)
- [ ] Set up backend for PassKit if needed
- [ ] Configure push notifications (if planned)
- [ ] Add app store screenshots
- [ ] Write app description
- [ ] Submit for review

## Support

For issues or questions during setup:
1. Check the build errors in Xcode
2. Review this guide
3. Check the README.md for feature documentation
4. Contact the development team
