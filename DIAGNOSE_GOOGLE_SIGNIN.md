# Google Sign-In Diagnostic Guide

## Step 1: Check Console Logs

Run the app with verbose logging:
```bash
flutter run -v
```

Look for these specific error messages:

### Error Code: 10
**Meaning:** Developer error - usually SHA-1 or package name mismatch
**Fix:**
1. Get SHA-1: `cd android && gradlew signingReport`
2. Add to Firebase Console → Project Settings → Your apps → Add fingerprint
3. Wait 5-10 minutes
4. Rebuild app

### Error Code: 12500
**Meaning:** Sign-in was cancelled by user
**Fix:** This is normal - user clicked cancel. Not an error.

### Error Code: 7
**Meaning:** Network error
**Fix:** Check internet connection

### Error Code: 8
**Meaning:** Internal error
**Fix:** Try again, or check Firebase project status

## Step 2: Verify Firebase Configuration

### Check google-services.json
1. Open `android/app/google-services.json`
2. Verify `package_name` is `"com.engitrack.engitrack"`
3. Check that `oauth_client` section exists with `client_type: 1` (Android)

### Check Package Name Match
1. `android/app/build.gradle.kts` → `applicationId = "com.engitrack.engitrack"`
2. `google-services.json` → `package_name: "com.engitrack.engitrack"`
3. Firebase Console → Your Android app → Package name

**All three must match exactly!**

## Step 3: Verify SHA-1 Certificate

### Get SHA-1:
```bash
cd android
gradlew signingReport
```

Look for:
```
Variant: debug
Config: debug
Store: C:\Users\...\.android\debug.keystore
Alias: AndroidDebugKey
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

### Add to Firebase:
1. Firebase Console → Project Settings
2. Your apps → Android app
3. Add fingerprint
4. Paste SHA-1
5. Save

**Important:** Add BOTH debug and release SHA-1 if you plan to release the app.

## Step 4: Enable Google Sign-In in Firebase

1. Firebase Console → Authentication
2. Sign-in method tab
3. Click "Google"
4. Toggle "Enable"
5. Enter Project support email
6. Click "Save"

## Step 5: Check OAuth Consent Screen

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project: `engitrack-514e8`
3. APIs & Services → OAuth consent screen
4. Make sure it's configured (can be "Testing" mode)

## Step 6: Test on Real Device

Emulators sometimes have issues with Google Sign-In. Try on a real Android device.

## Step 7: Clear Cache and Rebuild

```bash
flutter clean
cd android
gradlew clean
cd ..
flutter pub get
flutter run
```

## Step 8: Check Error Messages in App

The app now shows detailed error messages. When sign-in fails, check:
- The snackbar message for specific issues
- Console logs for detailed error codes

## Common Issues and Solutions

### Issue: "10: Developer error"
**Solution:** SHA-1 certificate missing or incorrect
1. Get SHA-1 from `gradlew signingReport`
2. Add to Firebase
3. Wait 5-10 minutes
4. Rebuild

### Issue: "Sign-in cancelled"
**Solution:** This is normal - user clicked cancel. Not an error.

### Issue: "Network error"
**Solution:** 
- Check internet connection
- Try on different network
- Check firewall settings

### Issue: "Internal error"
**Solution:**
- Check Firebase project status
- Verify all services are enabled
- Try again after a few minutes

### Issue: Nothing happens when clicking Google Sign-In
**Solution:**
- Check console logs for errors
- Verify Google Sign-In is enabled in Firebase
- Check internet permission in AndroidManifest.xml (already added)

## Quick Test Checklist

- [ ] SHA-1 added to Firebase
- [ ] Google Sign-In enabled in Firebase Console
- [ ] Package name matches everywhere
- [ ] google-services.json is up to date
- [ ] Internet permission in AndroidManifest.xml
- [ ] App rebuilt after changes
- [ ] Testing on device with internet
- [ ] Console logs checked for specific errors

## Still Not Working?

1. **Check the exact error message** in console logs
2. **Verify SHA-1** is correct and added to Firebase
3. **Wait 10 minutes** after adding SHA-1 (propagation time)
4. **Try on real device** instead of emulator
5. **Check Firebase project** is active and billing enabled (if required)

## Get Help

When asking for help, provide:
1. Exact error message from console
2. Error code (if any)
3. Whether SHA-1 is added to Firebase
4. Whether Google Sign-In is enabled
5. Device type (emulator/real device)

