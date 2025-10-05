import 'package:backdrp_fm/models/app_user.dart';

/// Mock user data for testing
class MockUsers {
  static final user1 = AppUser(
    uid: 'user_1',
    email: 'test1@backdrp.fm',
    displayName: 'Test User 1',
    profileImageUrl: 'https://ui-avatars.com/api/?name=Test+User+1&size=200',
    role: UserRole.user,
    emailSubscribed: true,
    pushSubscribed: true,
    likedVideos: ['video_1', 'video_2'],
    savedVideos: ['video_1'],
    preferences: UserPreferences(
      favoriteGenres: ['Electronic', 'Hip Hop'],
      notificationPreferences: NotificationPreferences(
        newSets: true,
        artistUpdates: true,
        weeklyDigest: true,
      ),
    ),
  );

  static final user2 = AppUser(
    uid: 'user_2',
    email: 'test2@backdrp.fm',
    displayName: 'Test User 2',
    profileImageUrl: 'https://ui-avatars.com/api/?name=Test+User+2&size=200',
    role: UserRole.user,
    emailSubscribed: false,
    pushSubscribed: true,
    likedVideos: ['video_2'],
    savedVideos: [],
    preferences: UserPreferences(
      favoriteGenres: ['R&B', 'Jazz'],
      notificationPreferences: NotificationPreferences(
        newSets: false,
        artistUpdates: true,
        weeklyDigest: false,
      ),
    ),
  );

  static final adminUser = AppUser(
    uid: 'admin_1',
    email: 'admin@backdrp.fm',
    displayName: 'Admin User',
    profileImageUrl: 'https://ui-avatars.com/api/?name=Admin&size=200',
    role: UserRole.admin,
    emailSubscribed: true,
    pushSubscribed: true,
    likedVideos: [],
    savedVideos: [],
    preferences: UserPreferences(
      favoriteGenres: [],
      notificationPreferences: NotificationPreferences(
        newSets: true,
        artistUpdates: true,
        weeklyDigest: true,
      ),
    ),
  );

  static List<AppUser> get allUsers => [user1, user2, adminUser];
  static List<AppUser> get regularUsers => [user1, user2];
}
