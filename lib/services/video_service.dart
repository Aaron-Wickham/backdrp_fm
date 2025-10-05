import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video.dart';
import '../config/environment.dart';

class VideoService {
  final FirebaseFirestore _firestore;

  VideoService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String get _videosCollection => AppEnvironment.getCollectionName('videos');

  // Get published videos stream
  // TODO: Add pagination support with startAfter/limit for better performance
  // TODO: Cache results to reduce Firestore reads
  Stream<List<Video>> getPublishedVideos() {
    return _firestore
        .collection(_videosCollection)
        .where('status', isEqualTo: 'published')
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList());
  }

  // Get featured videos with limit
  // TODO: Implement smart featured algorithm based on views, likes, and recency
  Stream<List<Video>> getFeaturedVideos({int limit = 10}) {
    return _firestore
        .collection(_videosCollection)
        .where('featured', isEqualTo: true)
        .orderBy('sortOrder')
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList());
  }

  // Get videos by artist
  Stream<List<Video>> getVideosByArtist(String artistId) {
    return _firestore
        .collection(_videosCollection)
        .where('artistId', isEqualTo: artistId)
        .where('status', isEqualTo: 'published')
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList());
  }

  // Get filtered videos
  Stream<List<Video>> getFilteredVideos({
    String? genre,
    String? artistId,
    DateTime? fromDate,
    DateTime? toDate,
    String? city,
    String? country,
  }) {
    Query query = _firestore
        .collection('videos')
        .where('status', isEqualTo: 'published');

    if (genre != null) {
      query = query.where('genres', arrayContains: genre);
    }

    if (artistId != null) {
      query = query.where('artistId', isEqualTo: artistId);
    }

    if (fromDate != null) {
      query = query.where('publishedDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate));
    }

    if (toDate != null) {
      query = query.where('publishedDate',
          isLessThanOrEqualTo: Timestamp.fromDate(toDate));
    }

    if (city != null) {
      query = query.where('location.city', isEqualTo: city);
    }

    if (country != null) {
      query = query.where('location.country', isEqualTo: country);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList());
  }

  // Get single video by ID
  Future<Video?> getVideo(String id) async {
    try {
      final doc = await _firestore.collection('videos').doc(id).get();
      if (doc.exists) {
        return Video.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Add video (admin only)
  Future<String?> addVideo({
    required String youtubeUrl,
    required String title,
    required String artist,
    required String artistId,
    required String description,
    required List<String> genres,
    required String venue,
    required String city,
    required String country,
    required int duration,
    DateTime? recordedDate,
    String status = 'draft',
    bool featured = false,
    int sortOrder = 0,
    List<String> tags = const [],
    double? latitude,
    double? longitude,
    String? soundcloudUrl,
    String? spotifyPlaylistId,
    String? appleMusicPlaylistId,
  }) async {
    try {
      // Extract YouTube ID
      final youtubeId = Video.extractYouTubeId(youtubeUrl);
      if (youtubeId == null) {
        throw Exception('Invalid YouTube URL');
      }

      // Generate thumbnail
      final thumbnailUrl = Video.getYouTubeThumbnail(youtubeId);

      // Create video object
      final videoData = {
        'youtubeUrl': youtubeUrl,
        'youtubeId': youtubeId,
        'thumbnailUrl': thumbnailUrl,
        'title': title,
        'artist': artist,
        'artistId': artistId,
        'description': description,
        'genres': genres,
        'location': {
          'venue': venue,
          'city': city,
          'country': country,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
        'duration': duration,
        if (recordedDate != null)
          'recordedDate': Timestamp.fromDate(recordedDate),
        'publishedDate': status == 'published'
            ? FieldValue.serverTimestamp()
            : null,
        'status': status,
        'likes': 0,
        'views': 0,
        'featured': featured,
        'sortOrder': sortOrder,
        'tags': tags,
        if (soundcloudUrl != null) 'soundcloudUrl': soundcloudUrl,
        if (spotifyPlaylistId != null) 'spotifyPlaylistId': spotifyPlaylistId,
        if (appleMusicPlaylistId != null)
          'appleMusicPlaylistId': appleMusicPlaylistId,
      };

      final docRef = await _firestore.collection('videos').add(videoData);

      // Update artist's total sets count
      await _firestore.collection('artists').doc(artistId).update({
        'totalSets': FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Update video
  Future<bool> updateVideo(String id, Map<String, dynamic> updates) async {
    try {
      // If YouTube URL is being updated, extract new ID and thumbnail
      if (updates.containsKey('youtubeUrl')) {
        final youtubeId = Video.extractYouTubeId(updates['youtubeUrl']);
        if (youtubeId == null) {
          throw Exception('Invalid YouTube URL');
        }
        updates['youtubeId'] = youtubeId;
        updates['thumbnailUrl'] = Video.getYouTubeThumbnail(youtubeId);
      }

      // If status is changing to published, set publishedDate
      if (updates['status'] == 'published') {
        updates['publishedDate'] = FieldValue.serverTimestamp();
      }

      await _firestore.collection('videos').doc(id).update(updates);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete video
  Future<bool> deleteVideo(String id, String artistId) async {
    try {
      await _firestore.collection('videos').doc(id).delete();

      // Decrement artist's total sets count
      await _firestore.collection('artists').doc(artistId).update({
        'totalSets': FieldValue.increment(-1),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Toggle like on video
  // TODO: Add rate limiting to prevent spam liking
  // TODO: Send notification to artist when video gets liked
  Future<bool> toggleLike(String videoId, String userId) async {
    try {
      final videoRef = _firestore.collection('videos').doc(videoId);
      final userRef = _firestore.collection('users').doc(userId);

      final userDoc = await userRef.get();
      final userData = userDoc.data();
      final likedVideos = List<String>.from(userData?['likedVideos'] ?? []);

      final isLiked = likedVideos.contains(videoId);

      // Run batch update
      final batch = _firestore.batch();

      if (isLiked) {
        // Unlike
        batch.update(videoRef, {
          'likes': FieldValue.increment(-1),
        });
        batch.update(userRef, {
          'likedVideos': FieldValue.arrayRemove([videoId]),
        });
      } else {
        // Like
        batch.update(videoRef, {
          'likes': FieldValue.increment(1),
        });
        batch.update(userRef, {
          'likedVideos': FieldValue.arrayUnion([videoId]),
        });
      }

      await batch.commit();
      return !isLiked; // Return new like state
    } catch (e) {
      return false;
    }
  }

  // Toggle save/bookmark video
  Future<bool> toggleSave(String videoId, String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();
      final userData = userDoc.data();
      final savedVideos = List<String>.from(userData?['savedVideos'] ?? []);

      final isSaved = savedVideos.contains(videoId);

      if (isSaved) {
        // Unsave
        await userRef.update({
          'savedVideos': FieldValue.arrayRemove([videoId]),
        });
      } else {
        // Save
        await userRef.update({
          'savedVideos': FieldValue.arrayUnion([videoId]),
        });
      }

      return !isSaved; // Return new save state
    } catch (e) {
      return false;
    }
  }

  // Increment video views
  Future<void> incrementViews(String videoId) async {
    try {
      await _firestore.collection('videos').doc(videoId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      // Silently fail for view tracking
    }
  }
}
