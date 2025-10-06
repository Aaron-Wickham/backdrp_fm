import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/cards/compact_video_card.dart';
import 'package:backdrp_fm/models/video.dart';

void main() {
  final testVideo = Video(
    id: 'video1',
    youtubeUrl: 'https://youtube.com/watch?v=test123',
    youtubeId: 'test123',
    thumbnailUrl: 'https://img.youtube.com/vi/test123/maxresdefault.jpg',
    title: 'Test Video',
    artist: 'Test Artist',
    artistId: 'artist1',
    description: 'Test description',
    genres: ['Electronic'],
    location: VideoLocation(
      venue: 'Test Venue',
      city: 'Los Angeles',
      country: 'USA',
    ),
    duration: 180,
    status: 'published',
    likes: 1500,
    views: 25000,
    featured: true,
    sortOrder: 1,
    tags: ['live'],
  );

  group('CompactVideoCard', () {
    testWidgets('displays video title in uppercase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('displays artist name in uppercase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      expect(find.text('TEST ARTIST'), findsOneWidget);
    });

    testWidgets('displays location information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      expect(find.text('LOS ANGELES, USA'), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('displays formatted likes count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      expect(find.text('1.5K'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('displays formatted views count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      expect(find.text('25.0K'), findsOneWidget);
      expect(find.byIcon(Icons.remove_red_eye_outlined), findsOneWidget);
    });

    testWidgets('formats numbers over 1M correctly', (tester) async {
      final videoWithManyViews = Video(
        id: 'video2',
        youtubeUrl: 'https://youtube.com/watch?v=test456',
        youtubeId: 'test456',
        thumbnailUrl: 'https://img.youtube.com/vi/test456/maxresdefault.jpg',
        title: 'Popular Video',
        artist: 'Popular Artist',
        artistId: 'artist2',
        description: 'Test description',
        genres: ['Electronic'],
        location: VideoLocation(
          venue: 'Test Venue',
          city: 'New York',
          country: 'USA',
        ),
        duration: 180,
        status: 'published',
        likes: 2500000,
        views: 1500000,
        featured: true,
        sortOrder: 1,
        tags: ['live'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: videoWithManyViews),
          ),
        ),
      );

      expect(find.text('2.5M'), findsOneWidget);
      expect(find.text('1.5M'), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(
              video: testVideo,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CompactVideoCard));
      expect(wasTapped, isTrue);
    });

    testWidgets('renders GestureDetector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('displays thumbnail image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders in a container with decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactVideoCard(video: testVideo),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CompactVideoCard),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.decoration, isNotNull);
    });
  });
}
