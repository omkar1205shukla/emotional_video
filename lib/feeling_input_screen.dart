import 'package:emotion_video/video_screen.dart'; // Ensure this import is correct based on your project structure
import 'package:flutter/material.dart';

class FeelingInputScreen extends StatefulWidget {
  const FeelingInputScreen({super.key});

  @override
  _FeelingInputScreenState createState() => _FeelingInputScreenState();
}

class _FeelingInputScreenState extends State<FeelingInputScreen>
    with SingleTickerProviderStateMixin {
  final _feelingController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        title: const Text(
          'Enter Your Feeling',
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
                image: AssetImage(
                    'assets/background.jpg'), // Ensure this image is available in your assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _feelingController,
                    decoration: const InputDecoration(
                      labelText: 'How are you feeling?',
                      labelStyle: TextStyle(
                        fontFamily: 'PoppinsFont',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'PoppinsFont',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      height:
                          40), // Increased space between TextField and button
                  ScaleTransition(
                    scale: _buttonAnimation,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoScreen(feeling: _feelingController.text),
                          ),
                        );
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _feelingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _buttonAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    _animationController.forward();
  }
}
