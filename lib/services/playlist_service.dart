import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/environment.dart';
import '../models/playlist.dart';

class PlaylistService {
  final FirebaseFirestore _firestore;

  PlaylistService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get all playlists stream
  Stream<List<Playlist>> getAllPlaylists() {
    return _firestore
        .collection(AppEnvironment.getCollectionName('playlists'))
        .orderBy('sortOrder')
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Playlist.fromFirestore(doc)).toList());
  }

  // Get featured playlists
  Stream<List<Playlist>> getFeaturedPlaylists({int limit = 10}) {
    return _firestore
        .collection(AppEnvironment.getCollectionName('playlists'))
        .where('featured', isEqualTo: true)
        .orderBy('sortOrder')
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Playlist.fromFirestore(doc)).toList());
  }

  // Get playlists by platform
  Stream<List<Playlist>> getPlaylistsByPlatform(MusicPlatform platform) {
    return _firestore
        .collection(AppEnvironment.getCollectionName('playlists'))
        .where('platform', isEqualTo: platform.name)
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Playlist.fromFirestore(doc)).toList());
  }

  // Get single playlist by ID
  Future<Playlist?> getPlaylist(String id) async {
    try {
      final doc = await _firestore.collection(AppEnvironment.getCollectionName('playlists')).doc(id).get();
      if (doc.exists) {
        return Playlist.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Add playlist (admin only)
  Future<String?> addPlaylist({
    required String title,
    String description = '',
    required MusicPlatform platform,
    required String platformUrl,
    String embedCode = '',
    String coverImageUrl = '',
    String curator = '',
    List<String> genres = const [],
    int trackCount = 0,
    bool featured = false,
    int sortOrder = 0,
  }) async {
    try {
      final playlistData = {
        'title': title,
        'description': description,
        'platform': platform.name,
        'platformUrl': platformUrl,
        'embedCode': embedCode,
        'coverImageUrl': coverImageUrl,
        'curator': curator,
        'genres': genres,
        'trackCount': trackCount,
        'publishedDate': FieldValue.serverTimestamp(),
        'featured': featured,
        'sortOrder': sortOrder,
      };

      final docRef = await _firestore.collection(AppEnvironment.getCollectionName('playlists')).add(playlistData);
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Update playlist
  Future<bool> updatePlaylist(String id, Map<String, dynamic> updates) async {
    try {
      // Convert MusicPlatform enum to string if present
      if (updates.containsKey('platform') &&
          updates['platform'] is MusicPlatform) {
        updates['platform'] = (updates['platform'] as MusicPlatform).name;
      }

      await _firestore.collection(AppEnvironment.getCollectionName('playlists')).doc(id).update(updates);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete playlist
  Future<bool> deletePlaylist(String id) async {
    try {
      await _firestore.collection(AppEnvironment.getCollectionName('playlists')).doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get playlists by genre
  Stream<List<Playlist>> getPlaylistsByGenre(String genre) {
    return _firestore
        .collection(AppEnvironment.getCollectionName('playlists'))
        .where('genres', arrayContains: genre)
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Playlist.fromFirestore(doc)).toList());
  }

  // Search playlists by title
  Stream<List<Playlist>> searchPlaylists(String query) {
    final queryLower = query.toLowerCase();
    return _firestore.collection(AppEnvironment.getCollectionName('playlists')).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Playlist.fromFirestore(doc))
            .where((playlist) =>
                playlist.title.toLowerCase().contains(queryLower) ||
                playlist.curator.toLowerCase().contains(queryLower))
            .toList());
  }
}
