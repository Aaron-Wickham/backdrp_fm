import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Mock YouTube player for testing that doesn't require platform implementation
class MockYoutubePlayer extends StatelessWidget {
  final YoutubePlayerController controller;
  final Widget Function(BuildContext, Widget)? builder;

  const MockYoutubePlayer({
    super.key,
    required this.controller,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final player = Container(
      height: 200,
      color: Colors.black,
      child: const Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 64,
          color: Colors.white,
        ),
      ),
    );

    return builder?.call(context, player) ?? player;
  }
}
