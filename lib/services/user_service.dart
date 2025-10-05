import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/environment.dart';
import '../models/app_user.dart';
import '../models/video.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get user profile stream
  Stream<AppUser?> getUserProfile(String userId) {
    return _firestore
        .collection(AppEnvironment.getCollectionName('users'))
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    });
  }

  // Update user profile
  Future<bool> updateUserProfile(
    String userId, {
    String? displayName,
    String? profileImageUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (displayName != null) {
        updates['displayName'] = displayName;
      }

      if (profileImageUrl != null) {
        updates['profileImageUrl'] = profileImageUrl;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).update(updates);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Update notification preferences
  Future<bool> updateNotificationPreferences(
    String userId, {
    bool? newSets,
    bool? artistUpdates,
    bool? weeklyDigest,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (newSets != null) {
        updates['preferences.notificationPreferences.newSets'] = newSets;
      }

      if (artistUpdates != null) {
        updates['preferences.notificationPreferences.artistUpdates'] =
            artistUpdates;
      }

      if (weeklyDigest != null) {
        updates['preferences.notificationPreferences.weeklyDigest'] =
            weeklyDigest;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).update(updates);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Update favorite genres
  Future<bool> updateFavoriteGenres(
    String userId,
    List<String> genres,
  ) async {
    try {
      await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).update({
        'preferences.favoriteGenres': genres,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user's liked videos stream
  Stream<List<Video>> getUserLikedVideos(String userId) {
    return _firestore
        .collection(AppEnvironment.getCollectionName('users'))
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      final userData = userDoc.data();
      final likedVideoIds = List<String>.from(userData?['likedVideos'] ?? []);

      if (likedVideoIds.isEmpty) {
        return <Video>[];
      }

      final videoDocs = await Future.wait(
        likedVideoIds.map(
          (id) => _firestore.collection('videos').doc(id).get(),
        ),
      );

      return videoDocs
          .where((doc) => doc.exists)
          .map((doc) => Video.fromFirestore(doc))
          .toList();
    });
  }

  // Get user's saved videos stream
  Stream<List<Video>> getUserSavedVideos(String userId) {
    return _firestore
        .collection(AppEnvironment.getCollectionName('users'))
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      final userData = userDoc.data();
      final savedVideoIds = List<String>.from(userData?['savedVideos'] ?? []);

      if (savedVideoIds.isEmpty) {
        return <Video>[];
      }

      final videoDocs = await Future.wait(
        savedVideoIds.map(
          (id) => _firestore.collection('videos').doc(id).get(),
        ),
      );

      return videoDocs
          .where((doc) => doc.exists)
          .map((doc) => Video.fromFirestore(doc))
          .toList();
    });
  }

  // Subscribe to email list
  Future<bool> subscribeToEmail(String userId, bool subscribe) async {
    try {
      await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).update({
        'emailSubscribed': subscribe,
      });

      // If subscribing, add to mailing list collection
      if (subscribe) {
        final userDoc = await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).get();
        final userData = userDoc.data();

        if (userData != null) {
          await _firestore.collection('mailingList').doc(userId).set({
            'email': userData['email'],
            'displayName': userData['displayName'],
            'subscribedDate': FieldValue.serverTimestamp(),
            'active': true,
          });
        }
      } else {
        // If unsubscribing, mark as inactive in mailing list
        await _firestore.collection('mailingList').doc(userId).update({
          'active': false,
          'unsubscribedDate': FieldValue.serverTimestamp(),
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Subscribe to push notifications
  Future<bool> subscribeToPush(String userId, bool subscribe) async {
    try {
      await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).update({
        'pushSubscribed': subscribe,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update last active timestamp
  Future<void> updateLastActive(String userId) async {
    try {
      await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silently fail
    }
  }

  // Get user by ID (single fetch)
  Future<AppUser?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(AppEnvironment.getCollectionName('users')).doc(userId).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
