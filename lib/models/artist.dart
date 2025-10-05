import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final String bannerImageUrl;
  final Map<String, String> socialLinks;
  final List<String> genres;
  final String location;
  final int totalSets;
  final DateTime? createdDate;
  final bool active;
  // TODO: Add verified badge field for official artist profiles
  // TODO: Add monthly listeners count
  // TODO: Add upcoming shows/tour dates
  // TODO: Add artist website URL separate from social links
  // TODO: Add record label information

  Artist({
    required this.id,
    required this.name,
    this.bio = '',
    this.profileImageUrl = '',
    this.bannerImageUrl = '',
    this.socialLinks = const {},
    this.genres = const [],
    this.location = '',
    this.totalSets = 0,
    this.createdDate,
    this.active = true,
  });

  factory Artist.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Artist(
      id: doc.id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      bannerImageUrl: data['bannerImageUrl'] ?? '',
      socialLinks: Map<String, String>.from(data['socialLinks'] ?? {}),
      genres: List<String>.from(data['genres'] ?? []),
      location: data['location'] ?? '',
      totalSets: data['totalSets'] ?? 0,
      createdDate: data['createdDate'] != null
          ? (data['createdDate'] as Timestamp).toDate()
          : null,
      active: data['active'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'bannerImageUrl': bannerImageUrl,
      'socialLinks': socialLinks,
      'genres': genres,
      'location': location,
      'totalSets': totalSets,
      if (createdDate != null) 'createdDate': Timestamp.fromDate(createdDate!),
      'active': active,
    };
  }
}
