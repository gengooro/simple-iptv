import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/widgets/flick_player/controls.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FlickPlayer extends StatefulWidget {
  final String url;
  final VideoFormat videoFormat;
  final String? streamIcon;
  final bool isLive;
  final bool autoPlay;
  final bool defaultFullscreen;

  const FlickPlayer({
    super.key,
    this.streamIcon = Constants.notAvailableImage,
    required this.url,
    required this.videoFormat,
    this.isLive = false,
    this.autoPlay = false,
    this.defaultFullscreen = false,
  });

  @override
  _FlickPlayerState createState() => _FlickPlayerState();
}

class _FlickPlayerState extends State<FlickPlayer> {
  late FlickManager flickManager;
  late VideoPlayerController videoPlayerController;
  final ValueNotifier<bool> isFullscreen = ValueNotifier(false);
  final ValueNotifier<bool> isVideoInitialized = ValueNotifier(false);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize VideoPlayerController safely
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
    );

    // Initialize FlickManager after VideoPlayerController is created
    flickManager = FlickManager(
      autoPlay: widget.autoPlay,
      videoPlayerController: videoPlayerController,
    );

    flickManager.flickControlManager?.addListener(() {
      if (flickManager.flickControlManager?.isFullscreen == true) {
        isFullscreen.value = true;
      } else {
        isFullscreen.value = false;
      }

      if (flickManager.flickVideoManager?.isVideoInitialized == true) {
        isVideoInitialized.value = true;
      }
    });

    debugPrint("Video is initialized: ${isVideoInitialized.value}");
  }

  @override
  void dispose() {
    flickManager.dispose();
    videoPlayerController.dispose();
    isFullscreen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFullscreen,
      builder: (context, isFullscreen, child) {
        return VisibilityDetector(
          key: ObjectKey(flickManager),
          onVisibilityChanged: (visibility) {
            if (visibility.visibleFraction == 0 && mounted) {
              flickManager.flickControlManager!.autoPause();
            } else if (visibility.visibleFraction == 1) {
              flickManager.flickControlManager!.autoResume();
            }
          },
          child: Column(
            children: <Widget>[
              if (flickManager.flickVideoManager?.isVideoInitialized == false)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.streamIcon ?? Constants.notAvailableImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset("assets/noimage1280x720.png"),
                        ),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Disable button while processing
                            if (videoPlayerController.value.isInitialized) {
                              return;
                            }

                            // Show loading state
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              // Initialize video first
                              await videoPlayerController.initialize();
                              if (mounted) {
                                setState(() {
                                  // Start playing
                                  videoPlayerController.play();
                                });
                              }
                            } catch (e) {
                              debugPrint("Error initializing video: $e");
                              // Optional: Show error to user
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: context.appColorScheme.onSurface,
                                  ),
                                )
                              : const Icon(Icons.play_arrow),
                        ),
                      ),
                    ],
                  ),
                )
              else
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    child: FlickVideoPlayer(
                      systemUIOverlayFullscreen: const [
                        SystemUiOverlay.top,
                        SystemUiOverlay.bottom,
                      ],
                      flickManager: flickManager,
                      preferredDeviceOrientationFullscreen: const [
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ],
                      flickVideoWithControls: FlickVideoWithControls(
                        backgroundColor: Colors.black,
                        playerLoadingFallback: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        controls: Builder(
                          builder: (context) => CustomOrientationControls(
                            isLive: widget.isLive,
                          ),
                        ),
                      ),
                      flickVideoWithControlsFullscreen: FlickVideoWithControls(
                        backgroundColor: Colors.black,
                        playerLoadingFallback: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        playerErrorFallback: const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                        videoFit: BoxFit.fitHeight,
                        controls: Builder(
                          builder: (context) => CustomOrientationControls(
                            isLive: widget.isLive,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
