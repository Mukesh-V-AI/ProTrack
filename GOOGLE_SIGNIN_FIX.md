# Google Sign-In Troubleshooting Guide

## Common Issues and Fixes

### Issue 1: "Google sign in failed" Error

This usually happens due to missing Firebase configuration. Follow these steps:

### Step 1: Get SHA-1 Certificate

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

Look for the SHA-1 fingerprint in the output. It will look like:
```
SHA1: A1:B2:C3:D4:E5:F6:...
```

### Step 2: Add SHA-1 to Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Project Settings** (gear icon)
4. Scroll down to **Your apps** section
5. Click on your Android app
6. Click **Add fingerprint**
7. Paste your SHA-1 certificate
8. Click **Save**

**Important:** You need to add both:
- **Debug SHA-1** (for testing)
- **Release SHA-1** (for production)

### Step 3: Enable Google Sign-In in Firebase

1. In Firebase Console, go to **Authentication**
2. Click **Sign-in method** tab
3. Find **Google** in the list
4. Click on it
5. Toggle **Enable**
6. Enter a **Project support email**
7. Click **Save**

### Step 4: Download Updated google-services.json

1. In Firebase Console → Project Settings
2. Scroll to **Your apps**
3. Click **Download google-services.json**
4. Replace the file in `android/app/google-services.json`

### Step 5: Verify OAuth Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** → **Credentials**
4. Look for **OAuth 2.0 Client IDs**
5. You should see:
   - **Android client** (auto-created by Firebase)
   - **Web client** (if web app is added)

### Step 6: Rebuild the App

```bash
flutter clean
flutter pub get
flutter build apk --debug
```

Or:
```bash
flutter run
```

## Issue 2: "Sign-in options failed" Error

### Check Firebase Authentication Settings

1. **Enable Email/Password:**
   - Firebase Console → Authentication → Sign-in method
   - Click **Email/Password**
   - Toggle **Enable**
   - Click **Save**

2. **Check Firestore Rules:**
   - Firebase Console → Firestore Database → Rules
   - Make sure rules allow authenticated users:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

## Issue 3: Network/Connection Errors

### Check Internet Permission

The `AndroidManifest.xml` should have:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

This has been added automatically.

### Check Device/Emulator

- Make sure device/emulator has internet connection
- Try on a real device if emulator has issues
- Check firewall/antivirus settings

## Issue 4: Package Name Mismatch

### Verify Package Name

1. Check `android/app/build.gradle.kts`:
   ```kotlin
   applicationId = "com.engitrack.engitrack"
   ```

2. Check `google-services.json`:
   - Open the file
   - Look for `"package_name": "com.engitrack.engitrack"`
   - They must match exactly!

## Issue 5: Google Sign-In Returns Null

This happens when user cancels the sign-in. The app now handles this gracefully.

If you want to show a message:
- The current implementation treats cancellation as a failed sign-in
- This is normal behavior

## Testing Checklist

- [ ] SHA-1 certificate added to Firebase
- [ ] Google Sign-In enabled in Firebase Console
- [ ] Email/Password enabled in Firebase Console
- [ ] `google-services.json` is up to date
- [ ] Package name matches in both places
- [ ] Internet permission in AndroidManifest.xml
- [ ] App rebuilt after changes
- [ ] Testing on device/emulator with internet

## Debug Steps

1. **Check Logs:**
   ```bash
   flutter run
   # Look for error messages in console
   ```

2. **Check Firebase Console:**
   - Authentication → Users (should show signed-in users)
   - Check for any error messages

3. **Test Email/Password First:**
   - If email/password works but Google doesn't, it's a Google Sign-In config issue
   - If both fail, check Firebase project setup

## Quick Fix Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
cd android
gradlew clean
cd ..
flutter build apk --debug

# Or just run
flutter run
```

## Still Not Working?

1. **Double-check SHA-1:**
   - Make sure you're using the correct SHA-1 (debug vs release)
   - Wait 5-10 minutes after adding SHA-1 for changes to propagate

2. **Verify Firebase Project:**
   - Make sure you're using the correct Firebase project
   - Check `google-services.json` matches your project

3. **Check Google Cloud Console:**
   - Ensure OAuth consent screen is configured
   - Check for any API restrictions

4. **Try on Real Device:**
   - Emulators sometimes have issues with Google Sign-In
   - Test on a physical Android device

## Error Messages Reference

- **"10:"** - Developer error (check SHA-1, package name)
- **"12500:"** - Sign-in cancelled by user
- **"7:"** - Network error (check internet)
- **"8:"** - Internal error (try again)

## Need More Help?

Check the console logs when running:
```bash
flutter run -v
```

This will show detailed error messages that can help identify the issue.

