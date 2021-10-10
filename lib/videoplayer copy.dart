import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final List<String> assetURLs;

  const VideoPlayerWidget({this.assetURLs: const []});
  @override
  _VideoPlayerWidget createState() => _VideoPlayerWidget();
}

class _VideoPlayerWidget extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  bool _isPlaying = false;
  bool _showControls = true;

  int currentVideoIndex = 0;

  @override
  void initState() {
    playNextVideo(currentVideoIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.removeListener(_videoPlayerListener);
    _videoController.dispose();
  }

  _videoPlayerListener() {
    // if (!_videoController.value.isPlaying &&
    //     !_videoController.value.isLooping) {
    //   //
    //   // Check if video completed
    //   if (checkIsFinished) {
    //     print("Video Completes - Moving To Next Video");
    //     playNextVideo();
    //   }
    //   // Move to next video

    //   //
    //   setState(() {
    //     _isPlaying = false;
    //     _showControls = true;
    //   });
    //   print("Playing : $_isPlaying || Showing Control : $_showControls");
    // }
  }

  bool get checkIsFinished =>
      !_videoController.value.isPlaying &&
      _videoController.value.isInitialized &&
      (_videoController.value.duration == _videoController.value.position);

  void playNextVideo([int? currentVideoIndex]) {
    if (currentVideoIndex == null) {
      print("Playing Next Video");

      /// when video completes
      currentVideoIndex = getNextVideoIndex;
    } else {
      print("Playing First Video");

      /// play's first video by default, because we send currentVideoIndex when it holds 0;
    }

    _videoController =
        VideoPlayerController.asset(widget.assetURLs[currentVideoIndex]);

    // if (_videoController.hasListeners) {
    //   _videoController.removeListener(_videoPlayerListener);
    // }
    //
    _videoController.initialize().then((_) {
      _videoController.addListener(_videoPlayerListener);
    });
    setState(() {});
  }

  int get getNextVideoIndex {
    if (widget.assetURLs.length != 0 &&
        currentVideoIndex < widget.assetURLs.length - 1) {
      return currentVideoIndex++;
    }
    return 0; // loop to first video
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
