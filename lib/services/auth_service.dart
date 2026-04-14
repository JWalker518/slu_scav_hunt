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

  bool get _shouldCheckPlatform => !_isTest && !kIsWeb && Platform.isWindows;

  Future<void> _ensureGoogleSignInInitialized() async {
    // google_sign_in does not natively support Windows.
    // Calling it on Windows will likely throw an UnimplementedError or hang.
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
      await _ensureGoogleSignInInitialized();
      
      // Trigger the authentication flow
      // In 7.x, cancellation might throw an exception instead of returning null
      final gsign.GoogleSignInAccount? googleUser;
      try {
        googleUser = await _googleSignIn.authenticate();
      } catch (e) {
        // Return null for canceled flow (common in 7.x exceptions)
        return null;
      }
      

      // Obtain the auth details from the result (synchronous in 7.x)
      final googleAuth = googleUser.authentication;

      // To get the access token in 7.x, we use the authorizationClient
      // authorizeScopes returns a GoogleSignInClientAuthorization
      final authorization = await googleUser.authorizationClient.authorizeScopes([]);

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
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
