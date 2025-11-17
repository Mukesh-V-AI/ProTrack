/// Google Sign-In Configuration Helper
/// 
/// This file helps configure Google Sign-In properly.
/// If you're getting errors, check:
/// 1. SHA-1 certificate is added to Firebase
/// 2. Google Sign-In is enabled in Firebase Console
/// 3. OAuth client is configured in Google Cloud Console

class GoogleSignInConfig {
  // Optional: If you have a web client ID, you can add it here
  // Get it from: Firebase Console → Project Settings → Your apps → Web app
  // Or: Google Cloud Console → APIs & Services → Credentials → OAuth 2.0 Client IDs
  static const String? webClientId = null; // Add your web client ID here if needed
  
  // For Android, the client ID is automatically configured via google-services.json
  // Make sure google-services.json is in android/app/ directory
}

