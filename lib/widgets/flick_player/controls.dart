import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/data/functions/player.dart';
import 'package:iptv/extension/theme.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CustomOrientationControls extends StatelessWidget {
  final bool isLive;

  const CustomOrientationControls({
    super.key,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    final flickVideoManager = Provider.of<FlickVideoManager>(context);
    final flickControlManager = Provider.of<FlickControlManager>(context);
    final videoPlayerController = flickVideoManager.videoPlayerController;

    final iconSize = flickControlManager.isFullscreen
        ? context.appTextTheme.labelMedium?.fontSize
        : context.appTextTheme.titleMedium?.fontSize;

    // Ensure the video player controller is available
    if (videoPlayerController == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Container(color: Colors.black38),
          ),
        ),
        Positioned.fill(
          child: FlickShowControlsAction(
              child: FlickSeekVideoAction(
            duration:
                const Duration(seconds: 1), // Adjusted duration for animation
            seekBackward: () {
              if (!isLive) {
                final currentPosition = videoPlayerController.value.position;
                final targetPosition =
                    currentPosition - const Duration(seconds: 10);
                videoPlayerController.seekTo(
                  targetPosition > Duration.zero
                      ? targetPosition
                      : Duration.zero,
                );
              }
            },
            seekForward: () {
              if (!isLive) {
                final currentPosition = videoPlayerController.value.position;
                final duration = videoPlayerController.value.duration;
                final targetPosition =
                    currentPosition + const Duration(seconds: 10);
                videoPlayerController.seekTo(
                  targetPosition <= duration ? targetPosition : duration,
                );
              }
            },
            child: Stack(
              children: [
                if (flickVideoManager.isBuffering)
                  const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                else
                  const Center(
                    child: FlickAutoHideChild(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FlickPlayToggle(size: 50),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            showIfVideoNotInitialized: true,
            autoHide: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      isLive
                          ? Text(
                              "LIVE",
                              style: context.appTextTheme.labelMedium?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Row(
                              children: <Widget>[
                                FlickCurrentPosition(
                                    fontSize: context
                                        .appTextTheme.labelSmall?.fontSize),
                                Text(
                                  ' / ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: context
                                        .appTextTheme.labelSmall?.fontSize,
                                  ),
                                ),
                                ValueListenableBuilder<VideoPlayerValue>(
                                  valueListenable: videoPlayerController,
                                  builder: (context, value, child) {
                                    final duration = value.duration;
                                    return Text(
                                      PlayerFunctions.formatDuration(duration),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: context
                                            .appTextTheme.labelSmall?.fontSize,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                      FlickFullScreenToggle(
                          size: iconSize,
                          padding: EdgeInsets.all(Constants.padding / 3)),
                    ],
                  ),
                  if (!isLive)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Constants.padding / 2,
                        left: Constants.padding / 2,
                        right: Constants.padding / 2,
                      ),
                      child: FlickVideoProgressBar(
                        flickProgressBarSettings: FlickProgressBarSettings(
                          height: 5,
                          handleRadius: 5,
                          curveRadius: 50,
                          backgroundColor: Colors.white24,
                          bufferedColor: Colors.white38,
                          playedColor: Colors.red,
                          handleColor: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
