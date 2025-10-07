import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../utils/app_logger.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current Firebase user
  User? get currentUser => _auth.currentUser;

  // Get current AppUser from Firestore
  Future<AppUser?> getCurrentAppUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting current app user', error: e);
      return null;
    }
  }

  // Sign up with email and password
  // TODO: Add email verification flow before full account access
  // TODO: Add OAuth providers (Google, Apple, Spotify)
  // TODO: Add username availability check
  // TODO: Implement rate limiting for signup attempts
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);

        // Determine role based on email
        final role = email.toLowerCase() == 'backdrp.fm@gmail.com'
            ? UserRole.admin
            : UserRole.user;

        // Create user document in Firestore
        final appUser = AppUser(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
          role: role,
          createdDate: DateTime.now(),
          lastActive: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(appUser.toFirestore());
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign up error: ${e.code} - ${e.message}', error: e);
      rethrow;
    } catch (e) {
      AppLogger.error('Unexpected sign up error', error: e);
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update last active
        await _firestore.collection('users').doc(credential.user!.uid).update({
          'lastActive': FieldValue.serverTimestamp(),
        });

        // Check if admin email and update role if needed
        if (email.toLowerCase() == 'backdrp.fm@gmail.com') {
          await _firestore.collection('users').doc(credential.user!.uid).set({
            'role': UserRole.admin.name,
          }, SetOptions(merge: true));
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in error: ${e.code} - ${e.message}', error: e);
      rethrow;
    } catch (e) {
      AppLogger.error('Unexpected sign in error', error: e);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      AppLogger.error('Sign out error', error: e);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Reset password error: ${e.code} - ${e.message}',
          error: e);
      rethrow;
    } catch (e) {
      AppLogger.error('Unexpected reset password error', error: e);
      rethrow;
    }
  }

  // Check if current user is admin
  Future<bool> isAdmin() async {
    final appUser = await getCurrentAppUser();
    return appUser?.isAdmin ?? false;
  }

  // Stream of current AppUser
  Stream<AppUser?> get currentAppUserStream {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return getCurrentAppUser();
    });
  }
}
