# Run EngiTrack in Chrome - Quick Start

## ⚡ Fastest Way (If Web App Already Added to Firebase)

If you've already added a web app to Firebase, just run:

```bash
flutter run -d chrome
```

## 🔧 If You Need to Add Web App First

### Quick Steps:

1. **Add Web App to Firebase:**
   - Go to: https://console.firebase.google.com/
   - Project: engitrack-514e8
   - Click Web icon (`</>`) → Register app
   - Copy the **App ID**

2. **Update Config:**
   - Open `lib/utils/firebase_config.dart`
   - Replace `YOUR_WEB_APP_ID` with your actual App ID

3. **Run:**
   ```bash
   flutter run -d chrome
   ```

## 🚀 Run Commands

```bash
# Run in Chrome (default port)
flutter run -d chrome

# Run on specific port
flutter run -d chrome --web-port=8080

# Run with hot reload
flutter run -d chrome --web-renderer html

# Build for web first, then run
flutter build web
# Then open build/web/index.html in Chrome
```

## 📝 Current Firebase Config

Your current config in `lib/utils/firebase_config.dart`:
- ✅ apiKey: Already set
- ✅ projectId: Already set (engitrack-514e8)
- ✅ authDomain: Already set
- ✅ storageBucket: Already set
- ⚠️ appId: Needs to be updated with your web app ID

## 🎯 What Happens When You Run

1. Flutter builds the web app
2. Chrome opens automatically
3. App loads at `http://localhost:xxxxx`
4. You can test all features in the browser!

## 🐛 Troubleshooting

### "Firebase not initialized"
- Make sure web app is added to Firebase
- Update appId in firebase_config.dart
- Rebuild: `flutter clean && flutter run -d chrome`

### "Google Sign-In not working"
- Enable Google Sign-In in Firebase Console
- Add `localhost` to authorized domains
- Check browser console (F12) for errors

### Chrome doesn't open
- Make sure Chrome is installed
- Try: `flutter run -d chrome --web-port=8080`
- Manually open: `http://localhost:8080`

