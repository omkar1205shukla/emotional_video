import 'package:emotion_video/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() => runApp(const MaterialApp(home: VideoScreen(feeling: 'happy')));

class VideoData {
  static final _instance = VideoData._internal();
  static VideoData get instance => _instance;

  List<String> videobuttondata = [];

  VideoData._internal();
}

class VideoScreen extends StatefulWidget {
  final String feeling;

  const VideoScreen({super.key, required this.feeling});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late String videoUrl;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _rating = 5.0; // Rating variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        title: const Text(
          'Video for Your Feeling',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'PoppinsFont',
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                  onReady: () {
                    VideoData._instance.videobuttondata
                        .add(_controller.initialVideoId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        duration: Duration(
                          seconds: 1,
                        ),
                        content: Text("Added To Your playlist"),
                      ),
                    );
                  },
                ),
                const Spacer(flex: 2),
                const Text(
                  'Rate this video:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PoppinsFont',
                  ),
                ),
                Slider(
                  value: _rating,
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: '${_rating.round()}',
                ),
                const Spacer(flex: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ScaleTransition(
                      scale: _animation,
                      child: ElevatedButton(
                        onPressed: () {
                          _showThankYouMessage();
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: 'PoppinsFont',
                          ),
                        ),
                      ),
                    ),

                    ScaleTransition(
                      scale: _animation,
                      child: ElevatedButton(
                        onPressed: () {
                          // _showThankYouMessage();
                        },
                        child: const Text(
                          'Add to Playlist',
                          style: TextStyle(
                            fontFamily: 'PoppinsFont',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Space between buttons

                    ScaleTransition(
                      scale: _animation,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Playlistscreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Playlist',
                          style: TextStyle(
                            fontFamily: 'PoppinsFont',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100), // Space below the buttons
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Set video URL based on feeling
    if (widget.feeling.toLowerCase().contains('happy')) {
      videoUrl = 'https://youtu.be/pApyQSxCNsA?si=UmOV4dknPV-pa5XX';
    } else if (widget.feeling.toLowerCase().contains('sad')) {
      videoUrl = 'https://youtu.be/Qi6uUGTJDCw?si=EDqA-N7OOpzj97vT';
    } else if (widget.feeling.toLowerCase().contains('excited')) {
      videoUrl = 'https://youtu.be/Khg9YXySztA?si=hVfE90K1-ZIYRuOk';
    } else if (widget.feeling.toLowerCase().contains('nervous')) {
      videoUrl = 'https://youtu.be/dXWbPcL2liA?si=gDT24n0OL9kBjxcu';
    } else {
      videoUrl = 'https://youtu.be/jeLZYAJ_A1Q?si=u4wRteetAGo51mIC';
    }

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _showThankYouMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thank You!',
            style: TextStyle(fontFamily: 'PoppinsFont'),
          ),
          content: Text(
            'Thank you for your rating of ${_rating.round()}!',
            style: const TextStyle(fontFamily: 'PoppinsFont'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(fontFamily: 'PoppinsFont'),
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
