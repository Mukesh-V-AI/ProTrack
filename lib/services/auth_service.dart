import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  GoogleSignIn get _googleSignIn {
    // Configure Google Sign-In
    // For Android, client ID comes from google-services.json automatically
    // For iOS/Web, you may need to specify serverClientId
    return GoogleSignIn(
      scopes: ['email', 'profile'],
      // Uncomment and add web client ID if needed for web/iOS
      // serverClientId: GoogleSignInConfig.webClientId,
    );
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        print('Starting Google Sign-In...');
      }
      
      // Sign out first to clear any cached accounts
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        if (kDebugMode) {
          print('Google Sign-In cancelled by user');
        }
        return null;
      }

      if (kDebugMode) {
        print('Google user signed in: ${googleUser.email}');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get ID token from Google. Check SHA-1 certificate in Firebase.');
      }

      if (kDebugMode) {
        print('Got Google authentication tokens');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (kDebugMode) {
        print('Signing in to Firebase with Google credential...');
      }

      final userCredential = await _auth.signInWithCredential(credential);
      
      if (kDebugMode) {
        print('Successfully signed in: ${userCredential.user?.email}');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In Error: $e');
        print('Error type: ${e.runtimeType}');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}


