# Run EngiTrack in Google Chrome (Windows)

## Quick Start

### Step 1: Add Web App to Firebase (Required)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **engitrack-514e8**
3. Click the **Web icon** (`</>`) or "Add app" → Web
4. Register your app:
   - **App nickname**: EngiTrack Web (or any name)
   - **Also set up Firebase Hosting**: No (uncheck)
5. Click **Register app**
6. **Copy the Firebase configuration** - you'll see something like:
   ```javascript
   const firebaseConfig = {
     apiKey: "AIzaSy...",
     authDomain: "engitrack-514e8.firebaseapp.com",
     projectId: "engitrack-514e8",
     storageBucket: "engitrack-514e8.firebasestorage.app",
     messagingSenderId: "206592497232",
     appId: "1:206592497232:web:xxxxxxxxxxxxx"
   };
   ```

### Step 2: Update Firebase Config

1. Open `lib/utils/firebase_config.dart`
2. Replace the `appId` with the one from Firebase Console
3. The other values are already set from your project

### Step 3: Enable Web Support

Flutter web is already enabled. Just run:

```bash
flutter run -d chrome
```

Or specify Chrome explicitly:

```bash
flutter run -d windows
```

## Detailed Steps

### Option 1: Run Directly in Chrome (Easiest)

```bash
# Make sure you're in the project directory
cd E:\projects\engitrack

# Run in Chrome
flutter run -d chrome
```

This will:
- Build the web app
- Launch Chrome automatically
- Open the app at `http://localhost:xxxxx`

### Option 2: Build and Serve

```bash
# Build for web
flutter build web

# The files will be in build/web/
# You can open index.html directly in Chrome, or use a local server
```

### Option 3: Use Flutter Dev Server

```bash
# Run with hot reload in Chrome
flutter run -d chrome --web-port=8080
```

Then open: `http://localhost:8080`

## Firebase Web Configuration

### Get Your Web App ID

1. Firebase Console → Project Settings
2. Scroll to **Your apps** section
3. Find your **Web app** (or add one if not exists)
4. Copy the **App ID** (looks like: `1:206592497232:web:xxxxxxxxxxxxx`)

### Update firebase_config.dart

Open `lib/utils/firebase_config.dart` and update:

```dart
appId: '1:206592497232:web:YOUR_ACTUAL_WEB_APP_ID', // Replace this
```

All other values are already correct from your project.

## Enable Google Sign-In for Web

1. Firebase Console → Authentication → Sign-in method
2. Click **Google**
3. Make sure it's **Enabled**
4. Add **Authorized domains**:
   - `localhost` (for local testing)
   - Your domain (for production)

## Troubleshooting

### "Firebase not initialized" Error

**Fix:** Make sure you've:
1. Added web app to Firebase
2. Updated `appId` in `firebase_config.dart`
3. Rebuilt the app

### "Google Sign-In not working"

**Fix:**
1. Enable Google Sign-In in Firebase Console
2. Add `localhost` to authorized domains
3. Make sure web app is added to Firebase

### "Build failed"

**Fix:**
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Chrome doesn't open

**Fix:**
1. Make sure Chrome is installed
2. Try: `flutter run -d chrome --web-port=8080`
3. Manually open: `http://localhost:8080`

## Quick Commands

```bash
# Run in Chrome
flutter run -d chrome

# Run on specific port
flutter run -d chrome --web-port=8080

# Build for web
flutter build web

# Clean and rebuild
flutter clean && flutter pub get && flutter run -d chrome
```

## Testing Checklist

- [ ] Web app added to Firebase
- [ ] Firebase config updated with web app ID
- [ ] Google Sign-In enabled in Firebase
- [ ] `localhost` added to authorized domains
- [ ] App runs in Chrome
- [ ] Can sign in with email
- [ ] Can sign in with Google
- [ ] Data syncs to Firestore

## Next Steps

Once it's working in Chrome:
1. Test all features
2. Check browser console for errors (F12)
3. Test on different browsers if needed
4. Deploy to production when ready

