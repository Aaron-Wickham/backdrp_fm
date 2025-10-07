import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/environment.dart';
import '../models/artist.dart';

class ArtistService {
  final FirebaseFirestore _firestore;

  ArtistService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get active artists stream
  Stream<List<Artist>> getActiveArtists() {
    return _firestore
        .collection(AppEnvironment.getCollectionName('artists'))
        .where('active', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Artist.fromFirestore(doc)).toList());
  }

  // Get single artist by ID
  Future<Artist?> getArtist(String id) async {
    try {
      final doc = await _firestore
          .collection(AppEnvironment.getCollectionName('artists'))
          .doc(id)
          .get();
      if (doc.exists) {
        return Artist.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get artists by genre
  Stream<List<Artist>> getArtistsByGenre(String genre) {
    return _firestore
        .collection(AppEnvironment.getCollectionName('artists'))
        .where('active', isEqualTo: true)
        .where('genres', arrayContains: genre)
        .orderBy('name')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Artist.fromFirestore(doc)).toList());
  }

  // Add artist (admin only)
  Future<String?> addArtist({
    required String name,
    String bio = '',
    String profileImageUrl = '',
    String bannerImageUrl = '',
    Map<String, String> socialLinks = const {},
    List<String> genres = const [],
    String location = '',
    bool active = true,
  }) async {
    try {
      final artistData = {
        'name': name,
        'bio': bio,
        'profileImageUrl': profileImageUrl,
        'bannerImageUrl': bannerImageUrl,
        'socialLinks': socialLinks,
        'genres': genres,
        'location': location,
        'totalSets': 0,
        'createdDate': FieldValue.serverTimestamp(),
        'active': active,
      };

      final docRef = await _firestore
          .collection(AppEnvironment.getCollectionName('artists'))
          .add(artistData);
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Update artist
  Future<bool> updateArtist(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection(AppEnvironment.getCollectionName('artists'))
          .doc(id)
          .update(updates);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Search artists by name
  Stream<List<Artist>> searchArtists(String query) {
    final queryLower = query.toLowerCase();
    return _firestore
        .collection(AppEnvironment.getCollectionName('artists'))
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Artist.fromFirestore(doc))
            .where((artist) => artist.name.toLowerCase().contains(queryLower))
            .toList());
  }
}
