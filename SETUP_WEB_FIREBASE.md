# Setup Firebase Web App - Quick Guide

## Step 1: Add Web App to Firebase (2 minutes)

1. **Go to Firebase Console:**
   - https://console.firebase.google.com/
   - Select project: **engitrack-514e8**

2. **Add Web App:**
   - Click the **Web icon** (`</>`) or click "Add app" → Web
   - **App nickname**: EngiTrack Web
   - **Also set up Firebase Hosting**: ❌ Uncheck (not needed for testing)
   - Click **Register app**

3. **Copy the Configuration:**
   You'll see a config like this:
   ```javascript
   const firebaseConfig = {
     apiKey: "AIzaSyCzgEJMYVCSJtCB4rtOjGLCVv0_lxBk9Ok",
     authDomain: "engitrack-514e8.firebaseapp.com",
     projectId: "engitrack-514e8",
     storageBucket: "engitrack-514e8.firebasestorage.app",
     messagingSenderId: "206592497232",
     appId: "1:206592497232:web:xxxxxxxxxxxxx"  // ← Copy this App ID
   };
   ```

4. **Copy the App ID** (the long string after `web:`)

## Step 2: Update firebase_config.dart

1. Open `lib/utils/firebase_config.dart`
2. Find this line:
   ```dart
   appId: '1:206592497232:web:YOUR_WEB_APP_ID',
   ```
3. Replace `YOUR_WEB_APP_ID` with the App ID you copied
4. Save the file

## Step 3: Enable Google Sign-In for Web

1. Firebase Console → **Authentication** → **Sign-in method**
2. Click **Google**
3. Make sure it's **Enabled**
4. Click **Save**

5. **Add Authorized Domain:**
   - In the same Google Sign-In settings
   - Scroll to **Authorized domains**
   - Click **Add domain**
   - Add: `localhost`
   - Click **Add**

## Step 4: Run in Chrome

After completing steps 1-3, run:

```bash
flutter run -d chrome
```

That's it! The app will open in Chrome.

