// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// enum VideoFit {
//   contain,
//   fill,
//   cover,
//   fitWidth,
//   fitHeight,
// }

// class LiveTvPlayer extends StatefulWidget {
//   final String url;

//   const LiveTvPlayer({super.key, required this.url});

//   @override
//   State<LiveTvPlayer> createState() => _LiveTvPlayerState();
// }

// class _LiveTvPlayerState extends State<LiveTvPlayer> {
//   late VideoPlayerController _controller;
//   bool _isBuffering = true;
//   bool _showControls = false;
//   VideoFit _currentFit = VideoFit.contain;
//   double _volume = 1.0; // Add this line

//   BoxFit _getBoxFit() {
//     switch (_currentFit) {
//       case VideoFit.contain:
//         return BoxFit.contain;
//       case VideoFit.fill:
//         return BoxFit.fill;
//       case VideoFit.cover:
//         return BoxFit.cover;
//       case VideoFit.fitWidth:
//         return BoxFit.fitWidth;
//       case VideoFit.fitHeight:
//         return BoxFit.fitHeight;
//     }
//   }

//   String _getFitText() {
//     switch (_currentFit) {
//       case VideoFit.contain:
//         return 'Contain';
//       case VideoFit.fill:
//         return 'Fill';
//       case VideoFit.cover:
//         return 'Cover';
//       case VideoFit.fitWidth:
//         return 'Fit Width';
//       case VideoFit.fitHeight:
//         return 'Fit Height';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//       widget.url,
//       videoPlayerOptions:
//           VideoPlayerOptions(mixWithOthers: false), // Add this line
//     )
//       ..initialize().then((_) {
//         setState(() {
//           _isBuffering = false;
//         });
//         SystemChrome.setPreferredOrientations([
//           DeviceOrientation.landscapeLeft,
//           DeviceOrientation.landscapeRight,
//         ]);
//         SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//         _controller.setVolume(_volume);
//       })
//       ..addListener(() {
//         final bool isPlaying = _controller.value.isPlaying;
//         if (isPlaying) {
//           setState(() {
//             _isBuffering = false;
//           });
//         }
//       })
//       ..setLooping(true)
//       ..play();
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleControls() {
//     setState(() {
//       _showControls = !_showControls;
//     });
//     if (_showControls) {
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted) {
//           setState(() {
//             _showControls = false;
//           });
//         }
//       });
//     }
//   }

//   void _showAspectRatioOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           color: Colors.black87,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: VideoFit.values.map((fit) {
//               return ListTile(
//                 title: Text(
//                   fit.toString().split('.').last,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 selected: _currentFit == fit,
//                 selectedTileColor: Colors.white24,
//                 onTap: () {
//                   setState(() {
//                     _currentFit = fit;
//                   });
//                   Navigator.pop(context);
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: _toggleControls,
//         child: Container(
//           color: Colors.black,
//           child: Center(
//             child: _controller.value.isInitialized
//                 ? Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       FittedBox(
//                         fit: _getBoxFit(),
//                         child: SizedBox(
//                           width: _controller.value.size.width,
//                           height: _controller.value.size.height,
//                           child: AspectRatio(
//                             aspectRatio: _controller.value.aspectRatio,
//                             child: VideoPlayer(_controller),
//                           ),
//                         ),
//                       ),

//                       if (_isBuffering)
//                         const CircularProgressIndicator(
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),

//                       // Close Button with Animation
//                       Positioned(
//                         right: 10.w,
//                         top: 16.h,
//                         child: AnimatedOpacity(
//                           opacity: _showControls ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 300),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: () => Navigator.of(context).pop(),
//                               child: Padding(
//                                 padding: EdgeInsets.all(8.r),
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Colors.white,
//                                   size: 16.sp,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Aspect Ratio Button
//                       Positioned(
//                         left: 10.w,
//                         top: 16.h,
//                         child: AnimatedOpacity(
//                           opacity: _showControls ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 300),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: _showAspectRatioOptions,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 12.w,
//                                   vertical: 6.h,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black45,
//                                   borderRadius: BorderRadius.circular(4.r),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.aspect_ratio,
//                                       color: Colors.white,
//                                       size: 16.sp,
//                                     ),
//                                     SizedBox(width: 4.w),
//                                     Text(
//                                       _getFitText(),
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Volume Control Button
//                       Positioned(
//                         right: 10.w,
//                         bottom: 16.h,
//                         child: AnimatedOpacity(
//                           opacity: _showControls ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 300),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     _volume == 0
//                                         ? Icons.volume_off
//                                         : Icons.volume_up,
//                                     color: Colors.white,
//                                     size: 24.sp,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _volume = _volume == 0 ? 1.0 : 0.0;
//                                       _controller.setVolume(_volume);
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(
//                                   width: 100.w,
//                                   child: SliderTheme(
//                                     data: SliderTheme.of(context).copyWith(
//                                       activeTrackColor: Colors.white,
//                                       inactiveTrackColor: Colors.white30,
//                                       thumbColor: Colors.white,
//                                       overlayColor: Colors.white.withAlpha(32),
//                                     ),
//                                     child: Slider(
//                                       value: _volume,
//                                       onChanged: (newValue) {
//                                         setState(() {
//                                           _volume = newValue;
//                                           _controller.setVolume(newValue);
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Play/Pause Button with Animation
//                       AnimatedOpacity(
//                         opacity: _showControls ? 1.0 : 0.0,
//                         duration: const Duration(milliseconds: 300),
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               if (_controller.value.isPlaying) {
//                                 _controller.pause();
//                               } else {
//                                 _controller.play();
//                               }
//                             });
//                           },
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: Colors.black45,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(12.r),
//                               child: Icon(
//                                 _controller.value.isPlaying
//                                     ? Icons.pause
//                                     : Icons.play_arrow,
//                                 size: 32.r,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 : const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
