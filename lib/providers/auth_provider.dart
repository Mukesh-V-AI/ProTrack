import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      debugPrint('Email Sign-In Error: $e');
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      await _authService.signUpWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      debugPrint('Email Sign-Up Error: $e');
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final result = await _authService.signInWithGoogle();
      if (result == null) {
        debugPrint('Google Sign-In was cancelled by user');
        return false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      debugPrint('Common fixes:');
      debugPrint('1. Check SHA-1 certificate is added to Firebase');
      debugPrint('2. Verify Google Sign-In is enabled in Firebase Console');
      debugPrint('3. Ensure package name matches: com.engitrack.engitrack');
      return false;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      debugPrint('Error type: ${e.runtimeType}');
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }
}

