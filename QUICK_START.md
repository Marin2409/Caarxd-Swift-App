# Caarxd Quick Start Guide

## 🚀 Get Running in 5 Minutes

### Step 1: Open Project (30 seconds)
```bash
cd /Users/josemarin/Developer/Caarxd-Swift-App
open Caarxd.xcodeproj
```

### Step 2: Add Files to Xcode (2 minutes)

#### Option A: Automatic (Recommended)
1. In Xcode Project Navigator, select existing files
2. Press `Delete` and choose "Remove References" (don't move to trash)
3. Right-click on "Caarxd" folder (blue one)
4. Select "Add Files to Caarxd..."
5. Select all these folders at once:
   - `Models/`
   - `Services/`
   - `Views/`
6. **Important**: UNCHECK "Copy items if needed"
7. Check "Create groups"
8. Ensure "Caarxd" target is checked
9. Click "Add"

#### Option B: Manual (if Option A doesn't work)
Drag each folder from Finder into Xcode Project Navigator:
- Drag `Models/` folder
- Drag `Services/` folder
- Drag `Views/` folder
- Ensure "Copy items if needed" is UNCHECKED
- Ensure "Create groups" is selected

### Step 3: Configure Permissions (1 minute)

1. Click on project name in Navigator
2. Select "Caarxd" under TARGETS
3. Click "Info" tab
4. Click the "+" button 3 times to add:

```
Privacy - Camera Usage Description
→ "We need camera access to scan business cards and QR codes"

Privacy - Photo Library Usage Description
→ "We need photo library access to save and select card images"

Privacy - Contacts Usage Description
→ "We need contacts access to sync your business contacts"
```

### Step 4: Set Team & Build (1 minute)

1. Go to "Signing & Capabilities" tab
2. Check "Automatically manage signing"
3. Select your Team from dropdown
4. Press `Cmd+B` to build
5. Press `Cmd+R` to run

### Step 5: Test Basic Features (1 minute)

When app launches:
1. Tap "Wallet" tab → Tap "+" → Create your first card
2. Tap "Home" tab → See your dashboard
3. Tap "Contacts" tab → View empty contacts list
4. Tap "Scan" tab → See scanner options

## ✅ You're Done!

The app is now running. All features are functional except:
- Camera scanning (needs real device)
- Apple Wallet (needs backend setup)

## 🔧 Quick Troubleshooting

### Build Error: "Cannot find type 'BusinessCard'"
**Fix**: Files not added to target
1. Select the failing file in Project Navigator
2. Open File Inspector (right panel)
3. Check "Caarxd" under Target Membership

### Build Error: "No such module 'VisionKit'"
**Fix**: Deployment target issue
1. Project Settings → General
2. Set "iOS Deployment Target" to 18.0

### App Crashes on Launch
**Fix**: Clean and rebuild
1. Press `Shift+Cmd+K` (Clean)
2. Press `Cmd+B` (Build)
3. Press `Cmd+R` (Run)

### Camera Not Working
**Fix**: This is normal in simulator
- Use a real iPhone for camera testing
- Simulator has limited camera support

## 📱 Testing on Real Device

1. Plug in iPhone
2. Select your iPhone from device dropdown
3. If "Untrusted Developer" appears on phone:
   - Go to Settings → General → VPN & Device Management
   - Trust your developer certificate
4. Run app with `Cmd+R`

## 🎨 Customization Quick Wins

### Change Default Card Colors
Edit `Caarxd/Models/BusinessCard.swift:66-67`:
```swift
primaryColor: String = "#YOUR_COLOR"  // Change #007AFF
secondaryColor: String = "#YOUR_COLOR" // Change #5856D6
```

### Add Sample Test Data
Edit `Caarxd/App/CaarxdApp.swift` and add before the closing brace:

```swift
// After modelContainer initialization
#if DEBUG
addSampleData()
#endif

// Add this function
private func addSampleData() {
    let context = modelContainer.mainContext

    let card = BusinessCard(
        firstName: "John",
        lastName: "Doe",
        title: "iOS Developer",
        company: "Tech Corp",
        email: "john@techcorp.com",
        phone: "+1 234 567 8900"
    )
    context.insert(card)
    try? context.save()
}
```

### Change App Display Name
1. Select project in Navigator
2. Under "Display Name" change "Caarxd" to your preferred name

## 📚 Next Steps

Once the app is running:

1. **Read the Docs**:
   - `README.md` - Feature overview
   - `SETUP_GUIDE.md` - Detailed configuration
   - `IMPLEMENTATION_SUMMARY.md` - Complete technical details

2. **Test All Features**:
   - Create multiple business cards
   - Add work cards
   - Create test contacts
   - View analytics
   - Try searching and filtering

3. **Plan Backend** (Optional):
   - Review backend options in SETUP_GUIDE.md
   - Choose Firebase or custom API
   - Plan PassKit implementation

4. **Customize UI**:
   - Adjust colors
   - Add app icon
   - Add launch screen

## 🆘 Still Having Issues?

1. Check file paths are correct
2. Ensure all 20 Swift files are visible in Xcode
3. Verify deployment target is iOS 18.0+
4. Check Bundle Identifier is unique
5. Make sure signing team is selected

## 📞 File Structure Verification

Run this in Terminal to verify all files exist:
```bash
cd /Users/josemarin/Developer/Caarxd-Swift-App
find Caarxd -name "*.swift" | wc -l
```
Should output: `20`

List all files:
```bash
find Caarxd -name "*.swift" | sort
```

## 🎯 Quick Reference

| Feature | Location | Status |
|---------|----------|--------|
| Business Cards | `Views/Wallet/` | ✅ Ready |
| Analytics | `Views/Home/HomeView.swift` | ✅ Ready |
| Scanning | `Views/Scan/ScanView.swift` | ⚠️ Needs device |
| Contacts | `Views/Contacts/` | ✅ Ready |
| QR Codes | `Services/QRCodeService.swift` | ✅ Ready |
| Sharing | `Services/SharingService.swift` | ✅ Ready |
| Analytics | `Services/AnalyticsService.swift` | ✅ Ready |
| PassKit | `Services/PassKitService.swift` | 🔧 Needs backend |

---

**Ready to go? Open Xcode and start building!** 🚀
