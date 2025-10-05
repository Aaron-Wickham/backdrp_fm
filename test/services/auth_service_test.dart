import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:backdrp_fm/services/auth_service.dart';
import 'package:backdrp_fm/models/app_user.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  User,
  UserCredential,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionRef;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
    mockDocRef = MockDocumentReference<Map<String, dynamic>>();
    mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    authService = AuthService(
      auth: mockAuth,
      firestore: mockFirestore,
    );
  });

  group('AuthService', () {
    test('currentUser returns Firebase current user', () {
      when(mockAuth.currentUser).thenReturn(mockUser);

      final result = authService.currentUser;

      expect(result, mockUser);
      verify(mockAuth.currentUser).called(1);
    });

    test('authStateChanges returns stream from Firebase Auth', () {
      final stream = Stream<User?>.value(mockUser);
      when(mockAuth.authStateChanges()).thenAnswer((_) => stream);

      final result = authService.authStateChanges;

      expect(result, stream);
      verify(mockAuth.authStateChanges()).called(1);
    });

    group('getCurrentAppUser', () {
      test('returns null when no user is signed in', () async {
        when(mockAuth.currentUser).thenReturn(null);

        final result = await authService.getCurrentAppUser();

        expect(result, isNull);
        verify(mockAuth.currentUser).called(1);
      });

      test('returns AppUser when user exists in Firestore', () async {
        const userId = 'user123';
        final userData = {
          'uid': userId,
          'email': 'test@example.com',
          'displayName': 'Test User',
          'role': 'user',
          'createdDate': Timestamp.now(),
          'lastActive': Timestamp.now(),
        };

        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(userData);
        when(mockDocSnapshot.id).thenReturn(userId);

        final result = await authService.getCurrentAppUser();

        expect(result, isA<AppUser>());
        expect(result?.uid, userId);
        expect(result?.email, 'test@example.com');
      });

      test('returns null when Firestore doc does not exist', () async {
        const userId = 'user123';

        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(false);

        final result = await authService.getCurrentAppUser();

        expect(result, isNull);
      });

      test('returns null and catches exception', () async {
        const userId = 'user123';

        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenThrow(Exception('Firestore error'));

        final result = await authService.getCurrentAppUser();

        expect(result, isNull);
      });
    });

    group('signUp', () {
      test('creates user with email and password', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const displayName = 'Test User';
        const userId = 'user123';

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockUser.updateDisplayName(displayName))
            .thenAnswer((_) async => {});
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenAnswer((_) async => {});

        final result = await authService.signUp(
          email: email,
          password: password,
          displayName: displayName,
        );

        expect(result, mockUserCredential);
        verify(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
        verify(mockUser.updateDisplayName(displayName)).called(1);
        verify(mockDocRef.set(any)).called(1);
      });

      test('assigns admin role to backdrp.fm@gmail.com', () async {
        const email = 'backdrp.fm@gmail.com';
        const password = 'password123';
        const displayName = 'Admin User';
        const userId = 'admin123';

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockUser.updateDisplayName(displayName))
            .thenAnswer((_) async => {});
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenAnswer((_) async => {});

        await authService.signUp(
          email: email,
          password: password,
          displayName: displayName,
        );

        final captured =
            verify(mockDocRef.set(captureAny)).captured.single as Map;
        expect(captured['role'], 'admin');
      });

      test('assigns user role to regular emails', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const displayName = 'Test User';
        const userId = 'user123';

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockUser.updateDisplayName(displayName))
            .thenAnswer((_) async => {});
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenAnswer((_) async => {});

        await authService.signUp(
          email: email,
          password: password,
          displayName: displayName,
        );

        final captured =
            verify(mockDocRef.set(captureAny)).captured.single as Map;
        expect(captured['role'], 'user');
      });

      test('rethrows FirebaseAuthException', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const displayName = 'Test User';

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expect(
          () => authService.signUp(
            email: email,
            password: password,
            displayName: displayName,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('signIn', () {
      test('signs in user with email and password', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const userId = 'user123';

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.update(any)).thenAnswer((_) async => {});

        final result = await authService.signIn(
          email: email,
          password: password,
        );

        expect(result, mockUserCredential);
        verify(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
        verify(mockDocRef.update(any)).called(1);
      });

      test('updates lastActive timestamp on successful sign in', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const userId = 'user123';

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.update(any)).thenAnswer((_) async => {});

        await authService.signIn(email: email, password: password);

        verify(mockDocRef.update({'lastActive': FieldValue.serverTimestamp()}))
            .called(1);
      });

      test('updates role to admin for backdrp.fm@gmail.com', () async {
        const email = 'backdrp.fm@gmail.com';
        const password = 'password123';
        const userId = 'admin123';

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.update(any)).thenAnswer((_) async => {});
        when(mockDocRef.set(any, any)).thenAnswer((_) async => {});

        await authService.signIn(email: email, password: password);

        // Verify both update and set were called
        verify(mockDocRef.update(any)).called(1);
        verify(mockDocRef.set({'role': 'admin'}, any)).called(1);
      });

      test('rethrows FirebaseAuthException', () async {
        const email = 'test@example.com';
        const password = 'wrongpassword';

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        expect(
          () => authService.signIn(email: email, password: password),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('signOut', () {
      test('signs out current user', () async {
        when(mockAuth.signOut()).thenAnswer((_) async => {});

        await authService.signOut();

        verify(mockAuth.signOut()).called(1);
      });

      test('rethrows exceptions', () async {
        when(mockAuth.signOut()).thenThrow(Exception('Sign out error'));

        expect(
          () => authService.signOut(),
          throwsException,
        );
      });
    });

    group('resetPassword', () {
      test('sends password reset email', () async {
        const email = 'test@example.com';

        when(mockAuth.sendPasswordResetEmail(email: email))
            .thenAnswer((_) async => {});

        await authService.resetPassword(email: email);

        verify(mockAuth.sendPasswordResetEmail(email: email)).called(1);
      });

      test('rethrows FirebaseAuthException', () async {
        const email = 'invalid@example.com';

        when(mockAuth.sendPasswordResetEmail(email: email))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => authService.resetPassword(email: email),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('isAdmin', () {
      test('returns true when user is admin', () async {
        const userId = 'user123';
        final userData = {
          'uid': userId,
          'email': 'admin@example.com',
          'displayName': 'Admin User',
          'role': 'admin',
          'createdDate': Timestamp.now(),
          'lastActive': Timestamp.now(),
        };

        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(userData);
        when(mockDocSnapshot.id).thenReturn(userId);

        final result = await authService.isAdmin();

        expect(result, isTrue);
      });

      test('returns false when user is not admin', () async {
        const userId = 'user123';
        final userData = {
          'uid': userId,
          'email': 'test@example.com',
          'displayName': 'Test User',
          'role': 'user',
          'createdDate': Timestamp.now(),
          'lastActive': Timestamp.now(),
        };

        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(userData);
        when(mockDocSnapshot.id).thenReturn(userId);

        final result = await authService.isAdmin();

        expect(result, isFalse);
      });

      test('returns false when no user is signed in', () async {
        when(mockAuth.currentUser).thenReturn(null);

        final result = await authService.isAdmin();

        expect(result, isFalse);
      });
    });

    group('currentAppUserStream', () {
      test('returns stream of current AppUser', () {
        when(mockAuth.authStateChanges())
            .thenAnswer((_) => Stream<User?>.value(null));

        expect(authService.currentAppUserStream, isA<Stream<AppUser?>>());
      });
    });
  });
}
