import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsign;
import 'package:slu_scav_hunt/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleSignIn extends Mock implements gsign.GoogleSignIn {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockGoogleSignInAccount extends Mock implements gsign.GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements gsign.GoogleSignInAuthentication {}
class MockGoogleSignInAuthorizationClient extends Mock implements gsign.GoogleSignInAuthorizationClient {}
class MockGoogleSignInClientAuthorization extends Mock implements gsign.GoogleSignInClientAuthorization {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authService = AuthService(
      auth: mockAuth,
      googleSignIn: mockGoogleSignIn,
      isTest: true,
    );
    
    // Register fallback for OAuthCredential
    registerFallbackValue(GoogleAuthProvider.credential(accessToken: 'at', idToken: 'it'));
    
    // Default setup for initialization
    when(() => mockGoogleSignIn.initialize()).thenAnswer((_) async => {});
  });

  group('AuthService Tests', () {
    test('signInWithEmailAndPassword calls FirebaseAuth', () async {
      final mockCredential = MockUserCredential();
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockCredential);

      final result = await authService.signInWithEmailAndPassword(
          'test@example.com', 'password123');

      expect(result, equals(mockCredential));
      verify(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('registerWithEmailAndPassword calls FirebaseAuth', () async {
      final mockCredential = MockUserCredential();
      when(() => mockAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockCredential);

      final result = await authService.registerWithEmailAndPassword(
          'test@example.com', 'password123');

      expect(result, equals(mockCredential));
      verify(() => mockAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('signInWithGoogle success calls correct methods', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockAuthDetails = MockGoogleSignInAuthentication();
      final mockClient = MockGoogleSignInAuthorizationClient();
      final mockResult = MockGoogleSignInClientAuthorization();
      final mockCredential = MockUserCredential();

      when(() => mockGoogleSignIn.authenticate()).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenReturn(mockAuthDetails);
      when(() => mockAccount.authorizationClient).thenReturn(mockClient);
      when(() => mockClient.authorizeScopes(any())).thenAnswer((_) async => mockResult);
      when(() => mockResult.accessToken).thenReturn('access_token');
      when(() => mockAuthDetails.idToken).thenReturn('id_token');
      when(() => mockAuth.signInWithCredential(any())).thenAnswer((_) async => mockCredential);

      final result = await authService.signInWithGoogle();

      expect(result, equals(mockCredential));
      verify(() => mockGoogleSignIn.initialize()).called(1);
      verify(() => mockGoogleSignIn.authenticate()).called(1);
      verify(() => mockAccount.authentication).called(1);
      verify(() => mockAuth.signInWithCredential(any())).called(1);
    });

    test('signInWithGoogle returns null if user cancels (throws exception)', () async {
      when(() => mockGoogleSignIn.authenticate()).thenThrow(Exception('canceled'));

      final result = await authService.signInWithGoogle();

      expect(result, isNull);
      verify(() => mockGoogleSignIn.authenticate()).called(1);
      verifyNever(() => mockAuth.signInWithCredential(any()));
    });

    test('sendPasswordResetEmail calls FirebaseAuth', () async {
      when(() => mockAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .thenAnswer((_) async => {});

      await authService.sendPasswordResetEmail('test@example.com');

      verify(() => mockAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .called(1);
    });

    test('signOut calls both GoogleSignIn and FirebaseAuth', () async {
      when(() => mockGoogleSignIn.signOut())
          .thenAnswer((_) async => null);
      when(() => mockAuth.signOut())
          .thenAnswer((_) async {});

      await authService.signOut();

      verify(() => mockGoogleSignIn.initialize()).called(1);
      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockAuth.signOut()).called(1);
    });

    test('authStateChanges returns the stream from FirebaseAuth', () {
      final mockUser = MockUser();
      when(() => mockAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));

      final stream = authService.authStateChanges;

      expect(stream, emits(mockUser));
      verify(() => mockAuth.authStateChanges()).called(1);
    });
  });
}
