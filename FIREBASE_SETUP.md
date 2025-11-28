# Firebase Setup Guide for Caarxd

## Step 1: Add Firebase SDK via Swift Package Manager

1. Open your Xcode project `Caarxd.xcodeproj`
2. Go to **File → Add Package Dependencies...**
3. Enter this URL: `https://github.com/firebase/firebase-ios-sdk`
4. Click **Add Package**
5. Select the following Firebase products:
   - ✅ FirebaseAuth
   - ✅ FirebaseFirestore
   - ✅ FirebaseAnalytics
6. Click **Add Package**

**Note:** We're NOT using Firebase Storage to avoid billing charges. Images are stored locally and synced as Base64 in Firestore.

## Step 2: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or select an existing project
3. Name it **"Caarxd"** (or your preferred name)
4. **Disable** Google Analytics for now (optional - we're using Firebase Analytics instead)
5. Click **"Create project"**

## Step 3: Register iOS App

1. In your Firebase project, click the **iOS icon** (⊕)
2. Enter your Bundle ID: **`com.example.www.Caarxd`**
   - ⚠️ This MUST match your Xcode project's bundle identifier
   - To verify: Open Xcode → Select target "Caarxd" → General tab → Bundle Identifier
3. App Nickname: **Caarxd** (optional)
4. App Store ID: Leave blank for now
5. Click **"Register app"**

## Step 4: Download GoogleService-Info.plist

1. Download the **`GoogleService-Info.plist`** file
2. In Xcode, **drag and drop** the file into your project
   - Place it in the `Caarxd` folder (same level as `CaarxdApp.swift`)
   - ✅ Make sure "Copy items if needed" is checked
   - ✅ Make sure the target "Caarxd" is selected
3. Click **"Finish"**

⚠️ **IMPORTANT**: Do NOT commit `GoogleService-Info.plist` to version control!
Add it to your `.gitignore`:
```
# Firebase
GoogleService-Info.plist
```

## Step 5: Enable Firebase Authentication

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Click on **Email/Password**
3. Toggle **Enable** to ON
4. Click **"Save"**

## Step 6: Set Up Firestore Database

1. Go to **Firestore Database** in Firebase Console
2. Click **"Create database"**
3. Choose **"Start in production mode"**
4. Select a location closest to your users (e.g., `us-central1`)
5. Click **"Enable"**

### Configure Firestore Security Rules

Replace the default rules with these:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User profiles - users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Business cards subcollection
      match /businessCards/{cardId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // Analytics subcollection
      match /analytics/{analyticsId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Public card views (for sharing)
    match /publicCards/{cardId} {
      allow read: if true; // Anyone can view public cards
      allow write: if request.auth != null;
    }
  }
}
```

Click **"Publish"**

## Step 7: Enable Firebase Analytics

1. Go to **Analytics** → **Dashboard**
2. Analytics should be automatically enabled
3. No additional configuration needed

## Step 8: Build and Test

1. In Xcode, clean the build folder: **Product → Clean Build Folder** (Cmd+Shift+K)
2. Build the project: **Product → Build** (Cmd+B)
3. Run the app on simulator or device

## Verification Checklist

- [x] GoogleService-Info.plist added to project (✅ Done - in Caarxd folder)
- [ ] Firebase SDK added via Swift Package Manager
- [ ] Email/Password authentication enabled in Firebase
- [ ] Firestore database created with security rules
- [ ] App builds without errors
- [ ] Can create new account (sign up works)
- [ ] Can log in with created account
- [ ] Can log out

## Troubleshooting

### Build Errors

If you see Firebase import errors:
1. Make sure all Firebase packages are added in Xcode
2. Clean build folder and restart Xcode
3. Check that `GoogleService-Info.plist` is in the project

### Authentication Not Working

1. Verify Email/Password is enabled in Firebase Console
2. Check that `GoogleService-Info.plist` is correctly added
3. Look at Xcode console for Firebase error messages

### Firestore Permission Denied

1. Check that security rules are properly configured
2. Verify user is logged in before making Firestore calls
3. Check that the logged-in user ID matches the document path

## Next Steps

After Firebase is working:

1. **Test Authentication:**
   - Create a new account
   - Log out and log back in
   - Try password reset (optional)

2. **Test Card Creation:**
   - Create a business card
   - It should sync to Firestore
   - Check Firebase Console → Firestore to see the data

3. **Test Analytics:**
   - Share a card
   - View a card
   - Check Firebase Console → Analytics to see events

## Firebase Console Links

- **Project Overview:** https://console.firebase.google.com/project/YOUR_PROJECT_ID
- **Authentication:** https://console.firebase.google.com/project/YOUR_PROJECT_ID/authentication/users
- **Firestore:** https://console.firebase.google.com/project/YOUR_PROJECT_ID/firestore
- **Analytics:** https://console.firebase.google.com/project/YOUR_PROJECT_ID/analytics

## Support

If you encounter issues:
1. Check the Firebase Console for errors
2. Look at Xcode console output
3. Verify all configuration steps were completed
