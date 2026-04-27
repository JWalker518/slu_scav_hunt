import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsign;

class AuthService {
  final FirebaseAuth _auth;
  final gsign.GoogleSignIn _googleSignIn;
  final bool _isTest;
  bool _isGoogleSignInInitialized = false;

  AuthService({
    FirebaseAuth? auth,
    gsign.GoogleSignIn? googleSignIn,
    bool isTest = false,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? gsign.GoogleSignIn.instance,
        _isTest = isTest;

  bool get _shouldCheckPlatform => !_isTest && (kIsWeb || Platform.isWindows);

  Future<void> _ensureGoogleSignInInitialized() async {
    // google_sign_in initialization is not required on Web when using signInWithPopup,
    // and it's not supported on Windows.
    if (_shouldCheckPlatform) return;

    if (!_isGoogleSignInInitialized) {
      try {
        await _googleSignIn.initialize();
        _isGoogleSignInInitialized = true;
      } catch (e) {
        debugPrint('Google Sign-In initialization failed: $e');
        rethrow;
      }
    }
  }

  /// Stream of user authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get the currently signed-in user
  User? get currentUser => _auth.currentUser;

  /// Sign in with Email and Password
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

  /// Register with Email and Password
  Future<UserCredential?> registerWithEmailAndPassword(
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

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    // Check for Windows support explicitly
    if (_shouldCheckPlatform) {
      throw UnsupportedError('Google Sign-In is not natively supported on Windows. '
          'Please sign in with email/password.');
    }

    try {
      // For Web, it's most reliable to use Firebase's native signInWithPopup
      if (kIsWeb) {
        debugPrint('Using signInWithPopup for Web...');
        final googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      }

      // For Mobile (iOS/Android)
      debugPrint('Using google_sign_in for Mobile...');
      await _ensureGoogleSignInInitialized();
      
      // Trigger the authentication flow
      // In 7.x, authenticate() is the standard method for interactive sign-in.
      // It returns a non-nullable GoogleSignInAccount or throws on cancellation/error.
      final gsign.GoogleSignInAccount googleUser;
      try {
        googleUser = await _googleSignIn.authenticate();
      } catch (e) {
        debugPrint('Google Sign-In authentication error/cancel: $e');
        // If it's a cancellation, we return null to signal "not signed in but no crash"
        return null;
      }

      // In 7.x, tokens are split across different classes
      // 1. Get the idToken from authentication
      final googleAuth = googleUser.authentication;
      
      // 2. Get the accessToken from authorizationClient
      final clientAuth = await googleUser.authorizationClient.authorizeScopes([]);

      // Create a new credential for Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: clientAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Firebase Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    // Only attempt Google Sign-Out if not on Windows
    if (!_shouldCheckPlatform) {
      try {
        await _ensureGoogleSignInInitialized();
        await _googleSignIn.signOut();
      } catch (e) {
        // Log the error but don't rethrow, as we still want to sign out from Firebase
        debugPrint('Google Sign-Out error: $e');
      }
    }
    
    // Sign out from Firebase
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Firebase Sign-Out error: $e');
      rethrow;
    }
  }
}
