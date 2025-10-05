import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:backdrp_fm/models/app_user.dart';

void main() {
  group('UserRole', () {
    test('fromString returns correct role', () {
      expect(UserRole.fromString('admin'), UserRole.admin);
      expect(UserRole.fromString('user'), UserRole.user);
    });

    test('fromString returns user for invalid role', () {
      expect(UserRole.fromString('invalid'), UserRole.user);
    });
  });

  group('NotificationPreferences', () {
    test('creates with default values', () {
      final prefs = NotificationPreferences();

      expect(prefs.newSets, true);
      expect(prefs.artistUpdates, true);
      expect(prefs.weeklyDigest, true);
    });

    test('creates with custom values', () {
      final prefs = NotificationPreferences(
        newSets: false,
        artistUpdates: false,
        weeklyDigest: true,
      );

      expect(prefs.newSets, false);
      expect(prefs.artistUpdates, false);
      expect(prefs.weeklyDigest, true);
    });

    test('fromFirestore creates instance', () {
      final data = {
        'newSets': false,
        'artistUpdates': true,
        'weeklyDigest': false,
      };

      final prefs = NotificationPreferences.fromFirestore(data);

      expect(prefs.newSets, false);
      expect(prefs.artistUpdates, true);
      expect(prefs.weeklyDigest, false);
    });

    test('toFirestore converts to map', () {
      final prefs = NotificationPreferences(
        newSets: false,
        artistUpdates: true,
        weeklyDigest: false,
      );

      final map = prefs.toFirestore();

      expect(map['newSets'], false);
      expect(map['artistUpdates'], true);
      expect(map['weeklyDigest'], false);
    });
  });

  group('UserPreferences', () {
    test('creates with default values', () {
      final prefs = UserPreferences();

      expect(prefs.favoriteGenres, isEmpty);
      expect(prefs.notificationPreferences, isA<NotificationPreferences>());
    });

    test('creates with custom values', () {
      final notificationPrefs = NotificationPreferences(newSets: false);
      final prefs = UserPreferences(
        favoriteGenres: ['Electronic', 'House'],
        notificationPreferences: notificationPrefs,
      );

      expect(prefs.favoriteGenres, ['Electronic', 'House']);
      expect(prefs.notificationPreferences.newSets, false);
    });

    test('fromFirestore creates instance', () {
      final data = {
        'favoriteGenres': ['Electronic', 'House'],
        'notificationPreferences': {
          'newSets': false,
          'artistUpdates': true,
          'weeklyDigest': false,
        },
      };

      final prefs = UserPreferences.fromFirestore(data);

      expect(prefs.favoriteGenres, ['Electronic', 'House']);
      expect(prefs.notificationPreferences.newSets, false);
    });

    test('toFirestore converts to map', () {
      final prefs = UserPreferences(
        favoriteGenres: ['Electronic', 'House'],
      );

      final map = prefs.toFirestore();

      expect(map['favoriteGenres'], ['Electronic', 'House']);
      expect(map['notificationPreferences'], isA<Map>());
    });
  });

  group('AppUser', () {
    test('creates instance with required fields', () {
      final user = AppUser(
        uid: 'user1',
        email: 'test@example.com',
      );

      expect(user.uid, 'user1');
      expect(user.email, 'test@example.com');
      expect(user.displayName, '');
      expect(user.role, UserRole.user);
      expect(user.isAdmin, false);
      expect(user.likedVideos, isEmpty);
      expect(user.savedVideos, isEmpty);
    });

    test('isAdmin returns true for admin role', () {
      final user = AppUser(
        uid: 'user1',
        email: 'admin@example.com',
        role: UserRole.admin,
      );

      expect(user.isAdmin, true);
    });

    test('creates instance with all fields', () {
      final createdDate = DateTime(2024, 1, 1);
      final lastActive = DateTime(2024, 1, 15);
      final preferences = UserPreferences(
        favoriteGenres: ['Electronic'],
      );

      final user = AppUser(
        uid: 'user1',
        email: 'test@example.com',
        displayName: 'Test User',
        profileImageUrl: 'https://example.com/profile.jpg',
        role: UserRole.user,
        likedVideos: ['video1', 'video2'],
        savedVideos: ['video3'],
        emailSubscribed: true,
        pushSubscribed: false,
        preferences: preferences,
        createdDate: createdDate,
        lastActive: lastActive,
      );

      expect(user.displayName, 'Test User');
      expect(user.likedVideos, ['video1', 'video2']);
      expect(user.savedVideos, ['video3']);
      expect(user.pushSubscribed, false);
      expect(user.preferences.favoriteGenres, ['Electronic']);
    });

    test('fromFirestore creates instance from document', () async {
      final firestore = FakeFirebaseFirestore();
      final createdDate = DateTime(2024, 1, 1);
      final lastActive = DateTime(2024, 1, 15);

      await firestore.collection('users').doc('user1').set({
        'email': 'test@example.com',
        'displayName': 'Test User',
        'profileImageUrl': 'https://example.com/profile.jpg',
        'role': 'admin',
        'likedVideos': ['video1', 'video2'],
        'savedVideos': ['video3'],
        'emailSubscribed': true,
        'pushSubscribed': false,
        'preferences': {
          'favoriteGenres': ['Electronic'],
          'notificationPreferences': {
            'newSets': true,
            'artistUpdates': false,
            'weeklyDigest': true,
          },
        },
        'createdDate': Timestamp.fromDate(createdDate),
        'lastActive': Timestamp.fromDate(lastActive),
      });

      final doc = await firestore.collection('users').doc('user1').get();
      final user = AppUser.fromFirestore(doc);

      expect(user.uid, 'user1');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.role, UserRole.admin);
      expect(user.isAdmin, true);
      expect(user.likedVideos, ['video1', 'video2']);
      expect(user.preferences.favoriteGenres, ['Electronic']);
    });

    test('fromFirestore handles missing optional fields', () async {
      final firestore = FakeFirebaseFirestore();

      await firestore.collection('users').doc('user1').set({
        'email': 'test@example.com',
      });

      final doc = await firestore.collection('users').doc('user1').get();
      final user = AppUser.fromFirestore(doc);

      expect(user.displayName, '');
      expect(user.role, UserRole.user);
      expect(user.likedVideos, isEmpty);
      expect(user.createdDate, isNull);
    });

    test('toFirestore converts to map', () {
      final createdDate = DateTime(2024, 1, 1);
      final user = AppUser(
        uid: 'user1',
        email: 'test@example.com',
        displayName: 'Test User',
        role: UserRole.admin,
        likedVideos: ['video1'],
        createdDate: createdDate,
      );

      final map = user.toFirestore();

      expect(map['email'], 'test@example.com');
      expect(map['displayName'], 'Test User');
      expect(map['role'], 'admin');
      expect(map['likedVideos'], ['video1']);
      expect(map['createdDate'], isA<Timestamp>());
    });

    test('toFirestore excludes null dates', () {
      final user = AppUser(
        uid: 'user1',
        email: 'test@example.com',
      );

      final map = user.toFirestore();

      expect(map.containsKey('createdDate'), isFalse);
      expect(map.containsKey('lastActive'), isFalse);
    });
  });
}
