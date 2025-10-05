import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/models/video.dart';

void main() {
  // These tests only test the static utility methods of the Video class
  // VideoService tests would require Firebase initialization and are better suited for integration tests

  group('Video.extractYouTubeId', () {
    test('extracts ID from standard URL', () {
      final id = Video.extractYouTubeId('https://youtube.com/watch?v=dQw4w9WgXcQ');
      expect(id, 'dQw4w9WgXcQ');
    });

    test('extracts ID from short URL', () {
      final id = Video.extractYouTubeId('https://youtu.be/dQw4w9WgXcQ');
      expect(id, 'dQw4w9WgXcQ');
    });

    test('extracts ID from embed URL', () {
      final id = Video.extractYouTubeId('https://youtube.com/embed/dQw4w9WgXcQ');
      expect(id, 'dQw4w9WgXcQ');
    });

    test('returns null for invalid URL', () {
      final id = Video.extractYouTubeId('https://invalid.com/video');
      expect(id, isNull);
    });

    test('returns null for empty string', () {
      final id = Video.extractYouTubeId('');
      expect(id, isNull);
    });
  });

  group('Video.getYouTubeThumbnail', () {
    test('returns correct thumbnail URL', () {
      final thumbnail = Video.getYouTubeThumbnail('dQw4w9WgXcQ');
      expect(thumbnail, 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg');
    });

    test('returns correct thumbnail URL for different video ID', () {
      final thumbnail = Video.getYouTubeThumbnail('test123');
      expect(thumbnail, 'https://img.youtube.com/vi/test123/maxresdefault.jpg');
    });
  });
}
