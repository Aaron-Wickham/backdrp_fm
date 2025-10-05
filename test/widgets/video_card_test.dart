import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/cards/video_card_widget.dart';
import 'package:backdrp_fm/models/video.dart';

void main() {
  late Video testVideo;

  setUp(() {
    final testLocation = VideoLocation(
      venue: 'Test Venue',
      city: 'London',
      country: 'UK',
    );

    testVideo = Video(
      id: 'test1',
      youtubeUrl: 'https://youtube.com/watch?v=test1',
      youtubeId: 'test1',
      thumbnailUrl: 'https://img.youtube.com/vi/test1/maxresdefault.jpg',
      title: 'Test Video Title',
      artist: 'Test Artist',
      artistId: 'artist1',
      description: 'Test description',
      genres: ['Electronic', 'House'],
      location: testLocation,
      duration: 3600,
      status: 'published',
      likes: 100,
      views: 1000,
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: VideoCardWidget(
          video: testVideo,
          onTap: () {},
        ),
      ),
    );
  }

  group('VideoCardWidget', () {
    testWidgets('renders video title in uppercase', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      // The widget converts title to uppercase
      expect(find.text('TEST VIDEO TITLE'), findsOneWidget);
    });

    testWidgets('renders artist name in uppercase', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      // The widget converts artist name to uppercase
      expect(find.text('TEST ARTIST'), findsOneWidget);
    });

    testWidgets('displays thumbnail image', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Check for Image widget or CachedNetworkImage
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsWidgets);
    });

    testWidgets('taps to trigger callback', (WidgetTester tester) async {
      var tapped = false;

      final widget = MaterialApp(
        home: Scaffold(
          body: VideoCardWidget(
            video: testVideo,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.byType(VideoCardWidget));

      expect(tapped, true);
    });
  });
}
