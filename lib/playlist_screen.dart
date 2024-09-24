import 'package:emotion_video/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Playlistscreen extends StatelessWidget {
  const Playlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: VideoData.instance.videobuttondata.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: YoutubePlayer(
          controller: YoutubePlayerController(
              initialVideoId: VideoData.instance.videobuttondata[index]),
          showVideoProgressIndicator: true,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
      ),
    ));
  }
}
