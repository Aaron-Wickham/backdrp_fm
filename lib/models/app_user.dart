import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  admin,
  user;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.user,
    );
  }
}

class NotificationPreferences {
  final bool newSets;
  final bool artistUpdates;
  final bool weeklyDigest;
  // TODO: Add push notification preferences (separate from email)
  // TODO: Add notification schedule (quiet hours)
  // TODO: Add genre-specific notification preferences

  NotificationPreferences({
    this.newSets = true,
    this.artistUpdates = true,
    this.weeklyDigest = true,
  });

  factory NotificationPreferences.fromFirestore(Map<String, dynamic> data) {
    return NotificationPreferences(
      newSets: data['newSets'] ?? true,
      artistUpdates: data['artistUpdates'] ?? true,
      weeklyDigest: data['weeklyDigest'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'newSets': newSets,
      'artistUpdates': artistUpdates,
      'weeklyDigest': weeklyDigest,
    };
  }
}

class UserPreferences {
  final List<String> favoriteGenres;
  final NotificationPreferences notificationPreferences;
  // TODO: Add theme preference (dark/light/auto)
  // TODO: Add language preference for multi-language support
  // TODO: Add autoplay preference for videos
  // TODO: Add data saver mode preference

  UserPreferences({
    this.favoriteGenres = const [],
    NotificationPreferences? notificationPreferences,
  }) : notificationPreferences =
            notificationPreferences ?? NotificationPreferences();

  factory UserPreferences.fromFirestore(Map<String, dynamic> data) {
    return UserPreferences(
      favoriteGenres: List<String>.from(data['favoriteGenres'] ?? []),
      notificationPreferences: data['notificationPreferences'] != null
          ? NotificationPreferences.fromFirestore(
              data['notificationPreferences'] as Map<String, dynamic>)
          : NotificationPreferences(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'favoriteGenres': favoriteGenres,
      'notificationPreferences': notificationPreferences.toFirestore(),
    };
  }
}

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String profileImageUrl;
  final UserRole role;
  final List<String> likedVideos;
  final List<String> savedVideos;
  final bool emailSubscribed;
  final bool pushSubscribed;
  final UserPreferences preferences;
  final DateTime? createdDate;
  final DateTime? lastActive;
  // TODO: Add watch history tracking with timestamps
  // TODO: Add playlists created by user
  // TODO: Add bio/about field for user profiles
  // TODO: Add privacy settings (profile visibility, etc.)

  AppUser({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.profileImageUrl = '',
    this.role = UserRole.user,
    this.likedVideos = const [],
    this.savedVideos = const [],
    this.emailSubscribed = true,
    this.pushSubscribed = true,
    UserPreferences? preferences,
    this.createdDate,
    this.lastActive,
  }) : preferences = preferences ?? UserPreferences();

  bool get isAdmin => role == UserRole.admin;

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      role: UserRole.fromString(data['role'] ?? 'user'),
      likedVideos: List<String>.from(data['likedVideos'] ?? []),
      savedVideos: List<String>.from(data['savedVideos'] ?? []),
      emailSubscribed: data['emailSubscribed'] ?? true,
      pushSubscribed: data['pushSubscribed'] ?? true,
      preferences: data['preferences'] != null
          ? UserPreferences.fromFirestore(
              data['preferences'] as Map<String, dynamic>)
          : UserPreferences(),
      createdDate: data['createdDate'] != null
          ? (data['createdDate'] as Timestamp).toDate()
          : null,
      lastActive: data['lastActive'] != null
          ? (data['lastActive'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'likedVideos': likedVideos,
      'savedVideos': savedVideos,
      'emailSubscribed': emailSubscribed,
      'pushSubscribed': pushSubscribed,
      'preferences': preferences.toFirestore(),
      if (createdDate != null) 'createdDate': Timestamp.fromDate(createdDate!),
      if (lastActive != null) 'lastActive': Timestamp.fromDate(lastActive!),
    };
  }
}
