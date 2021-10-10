import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String assetURL;

  const VideoPlayerWidget({this.assetURL: ""});
  @override
  _VideoPlayerWidget createState() => _VideoPlayerWidget();
}

class _VideoPlayerWidget extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    _videoController = VideoPlayerController.asset(widget.assetURL);
    _videoController.initialize().then((_) {
      setState(() {});
      _videoController.addListener(_videoPlayerListener);
    });

    //
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.removeListener(_videoPlayerListener);
    _videoController.dispose();
  }

  _videoPlayerListener() {
    if (!_videoController.value.isPlaying &&
        !_videoController.value.isLooping) {
      // Move to next video
      setState(() {
        _isPlaying = false;
        _showControls = true;
      });
      print("Playing : $_isPlaying || Showing Control : $_showControls");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // color: _showControls ? Colors.white : Colors.black,
      color: Colors.black,
      child: Stack(
        children: [
          _videoController != null && _videoController.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    print("GestureDetector");
                    setState(() {
                      _showControls = !_showControls;
                    });
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                      if (_showControls) Container(color: Colors.black45),
                      if (_showControls)
                        Align(
                          alignment: Alignment.center,
                          child: _isPlaying
                              ? IconButton(
                                  padding: EdgeInsets.only(),
                                  icon: Icon(Icons.pause,
                                      size: 50, color: Colors.red),
                                  onPressed: () {
                                    print("pause");
                                    _videoController.pause();
                                    setState(() {
                                      _isPlaying = false;
                                      _showControls = !_showControls;
                                    });
                                    print(
                                        "Playing : $_isPlaying || Showing Control : $_showControls");
                                  },
                                )
                              : IconButton(
                                  padding: EdgeInsets.only(),
                                  icon: Icon(Icons.play_arrow,
                                      size: 50, color: Colors.red),
                                  onPressed: () {
                                    print("play");
                                    _videoController.play();
                                    setState(() {
                                      _isPlaying = true;
                                      _showControls = !_showControls;
                                    });
                                    print(
                                        "Playing : $_isPlaying || Showing Control : $_showControls");
                                  },
                                ),
                        ),
                      if (_showControls)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VideoProgressIndicator(
                            _videoController,
                            allowScrubbing: true,
                            padding: const EdgeInsets.all(15),
                          ),
                        ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
        ],
      ),
    ));
  }
}
