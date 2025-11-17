import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Initialize Firebase with platform-specific options
/// For web deployment, ensure Firebase web app is configured in Firebase Console
Future<void> initializeFirebase() async {
  if (kIsWeb) {
    // Firebase web configuration
    // Get these values from Firebase Console > Project Settings > Your apps > Web app
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCzgEJMYVCSJtCB4rtOjGLCVv0_lxBk9Ok', // From google-services.json
        appId: '1:206592497232:web:YOUR_WEB_APP_ID', // Need to get from Firebase Console
        messagingSenderId: '206592497232', // From google-services.json
        projectId: 'engitrack-514e8', // From google-services.json
        authDomain: 'engitrack-514e8.firebaseapp.com',
        storageBucket: 'engitrack-514e8.firebasestorage.app', // From google-services.json
      ),
    );
  } else {
    // For mobile platforms, use default initialization
    // This will use google-services.json (Android) or GoogleService-Info.plist (iOS)
    await Firebase.initializeApp();
  }
}

