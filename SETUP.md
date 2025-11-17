# EngiTrack Setup Guide

## Prerequisites

1. **Flutter SDK** (3.8.1 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Firebase Account**
   - Create account at: https://console.firebase.google.com/

3. **Developer Mode (Windows)**
   - Open Settings → Update & Security → For developers
   - Enable Developer Mode
   - Or run: `start ms-settings:developers`

## Step-by-Step Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Set Up Firebase

#### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "EngiTrack" (or your preferred name)
4. Follow the setup wizard

#### Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** sign-in method
4. Enable **Google** sign-in method
   - Add your app's SHA-1 certificate (for Android)
   - Get SHA-1: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`

#### Enable Cloud Firestore

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Start in **test mode** (for development)
4. Choose a location close to you

#### Add Firebase to Your App

**For Android:**

1. In Firebase Console, click the Android icon
2. Register app with package name: `com.engitrack.engitrack`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`
5. Update `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.4.0'
   }
   ```
6. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

**For iOS:**

1. In Firebase Console, click the iOS icon
2. Register app with bundle ID: `com.engitrack.engitrack`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`
5. Open `ios/Runner.xcworkspace` in Xcode
6. Drag `GoogleService-Info.plist` into the Runner folder

### 3. Generate Hive Adapters

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the required `.g.dart` files for Hive models.

### 4. Run the App

```bash
flutter run
```

## Troubleshooting

### Build Runner Issues

If you get errors about conflicting files:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase Issues

- Make sure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in the correct location
- Verify package name/bundle ID matches Firebase project
- Check that Authentication and Firestore are enabled in Firebase Console

### Windows Developer Mode

If you see "Building with plugins requires symlink support":
1. Enable Developer Mode in Windows Settings
2. Restart your terminal/IDE
3. Try running again

### Missing Dependencies

If you see import errors:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Next Steps

After setup:
1. Run the app
2. Sign up with email or Google
3. Start adding your tasks, assignments, and LeetCode entries!
4. Configure your daily LeetCode goal in Settings

## Development Notes

- Local data is stored using Hive (offline-first)
- Cloud sync happens automatically when online
- Notifications require proper platform setup (Android/iOS permissions)

