// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';

// class ChewiePlayer extends StatefulWidget {
//   final String url;
//   final VideoFormat format;
//   final bool isLive;
//   final bool defaultFullscreen;

//   const ChewiePlayer({
//     super.key,
//     required this.url,
//     required this.format,
//     this.isLive = false,
//     this.defaultFullscreen = false,
//   });

//   @override
//   State<ChewiePlayer> createState() => _ChewiePlayerState();
// }

// class _ChewiePlayerState extends State<ChewiePlayer> {
//   late VideoPlayerController _videoPlayerController;
//   late ChewieController _chewieController;
//   bool _isLoading = true;
//   bool _isPlaying = false;
//   bool _isFullscreen = false;

//   @override
//   void initState() {
//     super.initState();

//     _videoPlayerController = VideoPlayerController.networkUrl(
//       Uri.parse(widget.url),
//       formatHint: widget.format,
//       videoPlayerOptions: VideoPlayerOptions(
//         allowBackgroundPlayback: true,
//       ),
//     );

//     // Initialize the video player controller
//     _videoPlayerController.initialize().then((_) {
//       setState(() {
//         _isLoading = false; // Video has finished loading
//       });
//       // Start playing the video once it's initialized
//       _videoPlayerController.play();
//     });

//     // Listen to the video player's state changes
//     // _videoPlayerController.addListener(() {
//     //   debugPrint("IsPlaying: ${_videoPlayerController.value.isPlaying}");
//     //   setState(() {
//     //     _isPlaying = _videoPlayerController.value.isPlaying;
//     //   }); // Trigger a rebuild when the player state changes
//     // });

//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       allowMuting: true,
//       autoPlay: true,
//       isLive: widget.isLive,
//       allowFullScreen: true,
//       aspectRatio: 16 / 9,
//       deviceOrientationsOnEnterFullScreen: [
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ],
//       allowPlaybackSpeedChanging: !widget.isLive,
//       looping: !widget.isLive,
//       materialProgressColors: ChewieProgressColors(
//         backgroundColor: Colors.white,
//       ),
//       customControls: _buildCustomControls(), // Custom controls widget
//     );

//     if (widget.defaultFullscreen) {
//       _enterFullscreen();
//     }

//     _chewieController.addListener(() {
//       debugPrint(
//           "IsPlaying: ${_chewieController.videoPlayerController.value.isPlaying}");
//     });
//   }

//   // Build custom controls to hide the fullscreen button when in fullscreen
//   Widget _buildCustomControls() {
//     debugPrint("IsPlaying: ${_videoPlayerController.value.isPlaying}");

//     return Container(
//       child: Column(
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.more_vert),
//               ),
//             ],
//           ),

//           Expanded(
//             child: Center(
//               child: _isLoading
//                   ? const CircularProgressIndicator()
//                   : _isPlaying
//                       ? IconButton(
//                           onPressed: () {
//                             _videoPlayerController.pause();
//                           },
//                           icon: const Icon(Icons.pause),
//                         )
//                       : IconButton(
//                           onPressed: () {
//                             _videoPlayerController.play();
//                           },
//                           icon: const Icon(Icons.play_arrow),
//                         ),
//             ),
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               if (_isFullscreen)
//                 IconButton(
//                   onPressed: () {
//                     _exitFullscreen();
//                   },
//                   icon: const Icon(Icons.fullscreen_exit),
//                 )
//               else
//                 IconButton(
//                   onPressed: () {
//                     _enterFullscreen();
//                   },
//                   icon: const Icon(Icons.fullscreen),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _enterFullscreen() {
//     _chewieController.enterFullScreen();
//     setState(() {
//       _isFullscreen = true;
//     });
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   void _exitFullscreen() {
//     _chewieController.exitFullScreen();
//     setState(() {
//       _isFullscreen = false;
//     });
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     _videoPlayerController.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: Chewie(
//         controller: _chewieController,
//       ),
//     );
//   }
// }
