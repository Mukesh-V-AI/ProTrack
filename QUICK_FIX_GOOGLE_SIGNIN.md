# Quick Fix for Google Sign-In Issues

## ⚠️ Most Common Issue: SHA-1 Certificate

**90% of Google Sign-In failures are due to missing SHA-1 certificate in Firebase.**

## 🔧 Quick Fix (5 minutes)

### Step 1: Get Your SHA-1 Certificate

**Windows:**
```bash
cd android
gradlew signingReport
```

**Look for this in the output:**
```
Variant: debug
Config: debug
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

**Copy the SHA1 value** (the long string of letters and numbers separated by colons)

### Step 2: Add SHA-1 to Firebase

1. Go to: https://console.firebase.google.com/
2. Select project: **engitrack-514e8**
3. Click **⚙️ Project Settings** (gear icon, top left)
4. Scroll down to **Your apps** section
5. Click on your **Android app** (package: com.engitrack.engitrack)
6. Click **"Add fingerprint"** button
7. **Paste your SHA-1** certificate
8. Click **Save**

### Step 3: Wait 5-10 Minutes

Firebase needs time to propagate the changes. Wait 5-10 minutes.

### Step 4: Rebuild and Test

```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Check What Error You're Getting

Run the app and try Google Sign-In. Check the console output for:

### Error Code 10
**Meaning:** SHA-1 certificate issue
**Fix:** Follow Step 1-4 above

### Error Code 12500
**Meaning:** User cancelled (not an error)
**Fix:** Try again and complete the sign-in

### "Failed to get ID token"
**Meaning:** SHA-1 certificate not matching
**Fix:** 
1. Verify SHA-1 is correct
2. Make sure you added the **debug** SHA-1 (not release)
3. Wait 10 minutes after adding
4. Rebuild app

## ✅ Verify These Settings

### 1. Google Sign-In Enabled?
- Firebase Console → Authentication → Sign-in method
- Click "Google"
- Should be **Enabled** (toggle ON)
- If not, enable it and save

### 2. Package Name Matches?
- `android/app/build.gradle.kts` → `applicationId = "com.engitrack.engitrack"`
- `google-services.json` → `"package_name": "com.engitrack.engitrack"`
- Firebase Console → Your Android app → Package name

**All three must be exactly: `com.engitrack.engitrack`**

### 3. google-services.json Updated?
After adding SHA-1, you should:
1. Download new `google-services.json` from Firebase
2. Replace `android/app/google-services.json`
3. Rebuild app

## 🐛 Still Not Working?

### Get Detailed Error Message

Run with verbose logging:
```bash
flutter run -v
```

Look for error messages that start with:
- `Firebase Auth Error:`
- `Google Sign-In Error:`
- `Error code:`

### Common Solutions

1. **Try on Real Device**
   - Emulators sometimes have issues
   - Test on a physical Android device

2. **Clear App Data**
   - Uninstall the app
   - Reinstall and try again

3. **Check Internet Connection**
   - Google Sign-In requires internet
   - Try on different network

4. **Verify Firebase Project**
   - Make sure you're using the correct project
   - Check `google-services.json` matches your project

## 📱 Test Checklist

- [ ] SHA-1 certificate added to Firebase
- [ ] Waited 5-10 minutes after adding SHA-1
- [ ] Google Sign-In enabled in Firebase Console
- [ ] Package name matches everywhere
- [ ] App rebuilt after changes
- [ ] Testing on device with internet
- [ ] Checked console for specific error codes

## 🎯 Most Likely Fix

**If you haven't added SHA-1 yet, that's 99% the issue.**

1. Run: `cd android && gradlew signingReport`
2. Copy SHA-1
3. Add to Firebase Console
4. Wait 10 minutes
5. Rebuild app

This fixes 90% of Google Sign-In issues!

