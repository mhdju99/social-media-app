import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const ReelVideoPlayer({super.key, required this.videoUrl});

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late VideoPlayerController _videoController;
  bool _showPlayIcon = true;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // لإعادة بناء الواجهة بعد التهيئة
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _showPlayIcon = true;
      } else {
        _videoController.play();
        _showPlayIcon = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? GestureDetector(
            onTap: _togglePlayPause,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
                if (_showPlayIcon)
                  const Icon(Icons.play_circle_fill,
                      size: 64, color: Colors.white70),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}




// with controler
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

// class ReelVideoPlayer extends StatefulWidget {
//   final String videoUrl;

//   const ReelVideoPlayer({super.key, required this.videoUrl});

//   @override
//   State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
// }

// class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
//   late VideoPlayerController _videoController;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _chewieController = ChewieController(
//             videoPlayerController: _videoController,
//             autoPlay: false,
//             looping: false,
//             allowMuting: false,
//             autoInitialize: false,
//             // showOptions: false,
//             showControlsOnInitialize: false,
            


//             aspectRatio: _videoController.value.aspectRatio,
//           );
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _chewieController != null
//         ? Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: AspectRatio(
//               aspectRatio: _videoController.value.aspectRatio,
//               child: Chewie(controller: _chewieController!),
//             ),
//           )
//         : const Center(child: CircularProgressIndicator());
//   }
// }
