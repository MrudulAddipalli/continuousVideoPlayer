import 'package:flutter/material.dart';
import 'package:video_integration/videoplayer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: VideoPlayerWidget(
              assetURLs: [
                "assets/videos/video_22-07-2021_19-06-50.mp4",
                "assets/videos/video_22-07-2021_19-07-01.mp4",
              ],
              // assetURL: "assets/videos/video_22-07-2021_19-06-50.mp4",
            ),
          ),
        ),
      ),
    );
  }
}
