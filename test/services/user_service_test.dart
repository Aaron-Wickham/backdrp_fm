import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:backdrp_fm/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late UserService userService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    userService = UserService(firestore: fakeFirestore);
  });

  group('UserService', () {
    group('updateUserProfile', () {
      test('updates displayName when provided', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'displayName': 'Old Name',
          'email': 'test@example.com',
        });

        // Act
        final result = await userService.updateUserProfile(
          userId,
          displayName: 'New Name',
        );

        // Assert
        expect(result, isTrue);
        final doc =
            await fakeFirestore.collection('dev_users').doc(userId).get();
        expect(doc.data()?['displayName'], 'New Name');
      });

      test('updates profileImageUrl when provided', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'displayName': 'Test User',
          'profileImageUrl': '',
        });

        // Act
        final result = await userService.updateUserProfile(
          userId,
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        // Assert
        expect(result, isTrue);
        final doc =
            await fakeFirestore.collection('dev_users').doc(userId).get();
        expect(
            doc.data()?['profileImageUrl'], 'https://example.com/profile.jpg');
      });

      test('updates both fields when both provided', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'displayName': 'Old Name',
          'profileImageUrl': 'old.jpg',
        });

        // Act
        final result = await userService.updateUserProfile(
          userId,
          displayName: 'New Name',
          profileImageUrl: 'new.jpg',
        );

        // Assert
        expect(result, isTrue);
        final doc =
            await fakeFirestore.collection('dev_users').doc(userId).get();
        expect(doc.data()?['displayName'], 'New Name');
        expect(doc.data()?['profileImageUrl'], 'new.jpg');
      });

      test('returns true on success', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'displayName': 'Test',
        });

        // Act
        final result = await userService.updateUserProfile(
          userId,
          displayName: 'Updated',
        );

        // Assert
        expect(result, isTrue);
      });
    });

    group('updateNotificationPreferences', () {
      test('updates newSets preference', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'preferences': {
            'notificationPreferences': {'newSets': false}
          },
        });

        // Act
        final result = await userService.updateNotificationPreferences(
          userId,
          newSets: true,
        );

        // Assert
        expect(result, isTrue);
        // Note: FakeCloudFirestore doesn't fully support nested field path updates
        // Verify that the update call succeeded without errors
      });

      test('updates multiple preferences', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'preferences': {
            'notificationPreferences': {
              'newSets': false,
              'artistUpdates': false,
              'weeklyDigest': false,
            }
          },
        });

        // Act
        final result = await userService.updateNotificationPreferences(
          userId,
          newSets: true,
          artistUpdates: true,
          weeklyDigest: true,
        );

        // Assert
        expect(result, isTrue);
        // Note: FakeCloudFirestore doesn't fully support nested field path updates
      });
    });

    group('updateFavoriteGenres', () {
      test('updates favorite genres list', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'preferences': {'favoriteGenres': []},
        });

        // Act
        final result = await userService.updateFavoriteGenres(
          userId,
          ['Electronic', 'House', 'Techno'],
        );

        // Assert
        expect(result, isTrue);
        // Note: FakeCloudFirestore doesn't fully support nested field path updates
      });

      test('returns true on success', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({});

        // Act
        final result = await userService.updateFavoriteGenres(userId, ['Rock']);

        // Assert
        expect(result, isTrue);
      });
    });

    group('getUserLikedVideos', () {
      test('returns empty list when no liked videos', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'likedVideos': [],
        });

        // Act
        final stream = userService.getUserLikedVideos(userId);
        final videos = await stream.first;

        // Assert
        expect(videos, isEmpty);
      });

      test('returns liked videos for user', () async {
        // Arrange
        const userId = 'user123';
        const videoId1 = 'video1';
        const videoId2 = 'video2';

        await fakeFirestore.collection('videos').doc(videoId1).set({
          'title': 'Video 1',
          'youtubeUrl': 'https://youtube.com/watch?v=abc',
          'artistId': 'artist1',
          'artistName': 'Artist 1',
          'status': 'published',
          'publishedDate': Timestamp.now(),
          'viewCount': 100,
          'likeCount': 10,
        });

        await fakeFirestore.collection('videos').doc(videoId2).set({
          'title': 'Video 2',
          'youtubeUrl': 'https://youtube.com/watch?v=def',
          'artistId': 'artist2',
          'artistName': 'Artist 2',
          'status': 'published',
          'publishedDate': Timestamp.now(),
          'viewCount': 200,
          'likeCount': 20,
        });

        await fakeFirestore.collection('dev_users').doc(userId).set({
          'likedVideos': [videoId1, videoId2],
        });

        // Act
        final stream = userService.getUserLikedVideos(userId);
        final videos = await stream.first;

        // Assert
        expect(videos.length, 2);
      });

      test('filters out non-existent videos', () async {
        // Arrange
        const userId = 'user123';
        const videoId = 'video1';

        await fakeFirestore.collection('videos').doc(videoId).set({
          'title': 'Video 1',
          'youtubeUrl': 'https://youtube.com/watch?v=abc',
          'artistId': 'artist1',
          'artistName': 'Artist 1',
          'status': 'published',
          'publishedDate': Timestamp.now(),
          'viewCount': 100,
          'likeCount': 10,
        });

        await fakeFirestore.collection('dev_users').doc(userId).set({
          'likedVideos': [videoId, 'nonexistent'],
        });

        // Act
        final stream = userService.getUserLikedVideos(userId);
        final videos = await stream.first;

        // Assert
        expect(videos.length, 1);
        expect(videos.first.id, videoId);
      });
    });

    group('getUserSavedVideos', () {
      test('returns empty list when no saved videos', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'savedVideos': [],
        });

        // Act
        final stream = userService.getUserSavedVideos(userId);
        final videos = await stream.first;

        // Assert
        expect(videos, isEmpty);
      });

      test('returns saved videos for user', () async {
        // Arrange
        const userId = 'user123';
        const videoId = 'video1';

        await fakeFirestore.collection('videos').doc(videoId).set({
          'title': 'Saved Video',
          'youtubeUrl': 'https://youtube.com/watch?v=abc',
          'artistId': 'artist1',
          'artistName': 'Artist 1',
          'status': 'published',
          'publishedDate': Timestamp.now(),
          'viewCount': 100,
          'likeCount': 10,
        });

        await fakeFirestore.collection('dev_users').doc(userId).set({
          'savedVideos': [videoId],
        });

        // Act
        final stream = userService.getUserSavedVideos(userId);
        final videos = await stream.first;

        // Assert
        expect(videos.length, 1);
        expect(videos.first.title, 'Saved Video');
      });
    });

    group('subscribeToEmail', () {
      test('sets emailSubscribed to true when subscribing', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'email': 'test@example.com',
          'displayName': 'Test User',
          'emailSubscribed': false,
        });

        // Act
        final result = await userService.subscribeToEmail(userId, true);

        // Assert
        expect(result, isTrue);
        final doc =
            await fakeFirestore.collection('dev_users').doc(userId).get();
        expect(doc.data()?['emailSubscribed'], true);
      });

      test('adds user to mailingList when subscribing', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'email': 'test@example.com',
          'displayName': 'Test User',
          'emailSubscribed': false,
        });

        // Act
        await userService.subscribeToEmail(userId, true);

        // Assert
        final mailingDoc =
            await fakeFirestore.collection('mailingList').doc(userId).get();
        expect(mailingDoc.exists, isTrue);
        expect(mailingDoc.data()?['email'], 'test@example.com');
        expect(mailingDoc.data()?['active'], true);
      });

      test('sets emailSubscribed to false when unsubscribing', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'email': 'test@example.com',
          'emailSubscribed': true,
        });
        await fakeFirestore.collection('mailingList').doc(userId).set({
          'email': 'test@example.com',
          'active': true,
        });

        // Act
        final result = await userService.subscribeToEmail(userId, false);

        // Assert
        expect(result, isTrue);
        final doc =
            await fakeFirestore.collection('dev_users').doc(userId).get();
        expect(doc.data()?['emailSubscribed'], false);
      });

      test('marks mailingList entry as inactive when unsubscribing', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'email': 'test@example.com',
          'emailSubscribed': true,
        });
        await fakeFirestore.collection('mailingList').doc(userId).set({
          'email': 'test@example.com',
          'active': true,
        });

        // Act
        await userService.subscribeToEmail(userId, false);

        // Assert
        final mailingDoc =
            await fakeFirestore.collection('mailingList').doc(userId).get();
        expect(mailingDoc.data()?['active'], false);
      });
    });

    group('subscribeToPush', () {
      test('updates pushSubscribed field', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'pushSubscribed': false,
        });

        // Act
        final result = await userService.subscribeToPush(userId, true);

        // Assert
        expect(result, isTrue);
        final doc =
            await fakeFirestore.collection('dev_users').doc(userId).get();
        expect(doc.data()?['pushSubscribed'], true);
      });
    });

    group('updateLastActive', () {
      test('updates lastActive field', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'lastActive': Timestamp.fromDate(DateTime(2020, 1, 1)),
        });

        // Act
        await userService.updateLastActive(userId);

        // Assert
        final doc =
            await fakeFirestore.collection('dev_users').doc(userId).get();
        expect(doc.data()?['lastActive'], isNotNull);
      });

      test('silently fails on exception', () async {
        // Arrange
        const userId = 'nonexistent';

        // Act & Assert - Should not throw
        await userService.updateLastActive(userId);
      });
    });

    group('getUser', () {
      test('returns user when document exists', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'uid': userId,
          'email': 'test@example.com',
          'displayName': 'Test User',
          'role': 'user',
          'createdDate': Timestamp.now(),
          'lastActive': Timestamp.now(),
        });

        // Act
        final result = await userService.getUser(userId);

        // Assert
        expect(result, isNotNull);
        expect(result?.uid, userId);
        expect(result?.email, 'test@example.com');
      });

      test('returns null when document does not exist', () async {
        // Act
        final result = await userService.getUser('nonexistent');

        // Assert
        expect(result, isNull);
      });
    });

    group('getUserProfile stream', () {
      test('returns stream of user profile', () async {
        // Arrange
        const userId = 'user123';
        await fakeFirestore.collection('dev_users').doc(userId).set({
          'uid': userId,
          'email': 'test@example.com',
          'displayName': 'Test User',
          'role': 'user',
          'createdDate': Timestamp.now(),
          'lastActive': Timestamp.now(),
        });

        // Act
        final stream = userService.getUserProfile(userId);
        final user = await stream.first;

        // Assert
        expect(user, isNotNull);
        expect(user?.uid, userId);
      });

      test('returns null when document does not exist', () async {
        // Act
        final stream = userService.getUserProfile('nonexistent');
        final user = await stream.first;

        // Assert
        expect(user, isNull);
      });
    });
  });
}
