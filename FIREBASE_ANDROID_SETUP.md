# Firebase Android Setup Guide

This guide will help you complete the Firebase setup for your Android app.

## ✅ What Has Been Configured

The following Gradle files have been updated:

1. **`android/settings.gradle.kts`** - Added Google services plugin
2. **`android/app/build.gradle.kts`** - Added Firebase dependencies and Google services plugin

## 📋 Next Steps

### Step 1: Download google-services.json

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create a new one)
3. Click the **Android icon** (or "Add app" → Android)
4. Register your Android app:
   - **Package name**: `com.engitrack.engitrack` (must match your app's package name)
   - **App nickname**: EngiTrack (optional)
   - **Debug signing certificate SHA-1**: (optional, needed for Google Sign-In)
5. Click **Register app**
6. Download `google-services.json`
7. Place the file in: `android/app/google-services.json`

### Step 2: Get SHA-1 Certificate (For Google Sign-In)

To enable Google Sign-In, you need to add your app's SHA-1 certificate:

**Windows:**
```bash
cd android
gradlew signingReport
```

**Linux/Mac:**
```bash
cd android
./gradlew signingReport
```

Look for the SHA-1 fingerprint in the output and add it to Firebase Console:
- Firebase Console → Project Settings → Your Android app → Add fingerprint

### Step 3: Sync Gradle Files

1. Open Android Studio
2. Click **File** → **Sync Project with Gradle Files**
3. Or use the sync icon in the toolbar

**Or via command line:**
```bash
cd android
gradlew build
```

### Step 4: Verify Setup

1. Check that `google-services.json` is in `android/app/` directory
2. Verify Gradle sync completed without errors
3. Try building the app:
   ```bash
   flutter build apk --debug
   ```

## 🔍 Verification Checklist

- [ ] `google-services.json` is in `android/app/` directory
- [ ] Gradle files synced successfully
- [ ] No build errors
- [ ] SHA-1 certificate added to Firebase (for Google Sign-In)
- [ ] Firebase Authentication enabled in Firebase Console
- [ ] Cloud Firestore enabled in Firebase Console

## 📦 Firebase Dependencies Added

The following Firebase SDKs have been added to your project:

- **Firebase BoM (Bill of Materials)** - Version 34.5.0
  - Ensures all Firebase libraries use compatible versions
- **Firebase Analytics** - For app analytics
- **Firebase Authentication** - For user authentication
- **Cloud Firestore** - For database operations

## 🛠️ Troubleshooting

### Issue: Gradle Sync Fails

**Solution:**
1. Clean the project:
   ```bash
   cd android
   gradlew clean
   ```
2. Invalidate caches in Android Studio:
   - File → Invalidate Caches → Invalidate and Restart
3. Sync again

### Issue: "google-services.json not found"

**Solution:**
- Make sure `google-services.json` is in `android/app/` directory
- Check the file name is exactly `google-services.json` (case-sensitive)
- Re-download from Firebase Console if needed

### Issue: "Package name mismatch"

**Solution:**
- Ensure package name in `google-services.json` matches `com.engitrack.engitrack`
- Check `android/app/build.gradle.kts` → `applicationId` matches

### Issue: Build Errors Related to Firebase

**Solution:**
1. Check Firebase Console → Project Settings → Your apps
2. Verify all services are enabled (Authentication, Firestore)
3. Check that you're using the latest Firebase BoM version
4. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   cd android && gradlew clean && cd ..
   flutter build apk
   ```

## 🔐 Enable Firebase Services

Make sure these are enabled in Firebase Console:

1. **Authentication**
   - Go to Authentication → Sign-in method
   - Enable **Email/Password**
   - Enable **Google** (requires SHA-1 certificate)

2. **Cloud Firestore**
   - Go to Firestore Database
   - Create database (start in test mode for development)
   - Choose a location

## 📱 Testing

After setup, test the app:

```bash
# Run on connected device/emulator
flutter run

# Or build APK
flutter build apk --debug
```

## 🎯 What You Can Do Now

With Firebase configured, your app can:

1. ✅ **User Authentication**
   - Email/Password sign-in
   - Google Sign-In
   - User management

2. ✅ **Cloud Database**
   - Store assignments, exams, todos, notes
   - Real-time sync across devices
   - Offline support

3. ✅ **Analytics**
   - Track app usage
   - User engagement metrics

## 📚 Additional Resources

- [Firebase Android Documentation](https://firebase.google.com/docs/android/setup)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

## ⚠️ Important Notes

1. **Never commit `google-services.json` to public repositories**
   - It's already in `.gitignore`
   - Contains sensitive project information

2. **Use different Firebase projects for development and production**
   - Create separate projects
   - Use different `google-services.json` files

3. **Keep Firebase dependencies updated**
   - The BoM version (34.5.0) is current
   - Check for updates periodically

4. **Security Rules**
   - Configure Firestore security rules
   - Don't leave database open in production

## 🚀 Next Steps After Setup

1. Test authentication flow
2. Test data sync to Firestore
3. Configure Firestore security rules
4. Set up Firebase App Check (for production)
5. Configure Firebase Cloud Messaging (if needed for notifications)

