import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv/widgets/orientation_player/controls.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class CustomOrientationPlayer extends StatefulWidget {
  CustomOrientationPlayer({Key? key}) : super(key: key);

  @override
  _CustomOrientationPlayerState createState() =>
      _CustomOrientationPlayerState();
}

class _CustomOrientationPlayerState extends State<CustomOrientationPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(
            "http://cf.gocdn8k.me:80/movie/iptvflag7o3/7thi8mdmrj/1201842.mkv"),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  skipToVideo(String url) {
    flickManager
        .handleChangeVideo(VideoPlayerController.networkUrl(Uri.parse(url)));
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: FlickVideoPlayer(
              flickManager: flickManager,
              preferredDeviceOrientationFullscreen: [
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],
              flickVideoWithControls: FlickVideoWithControls(
                controls: CustomOrientationControls(),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.fitWidth,
                controls: CustomOrientationControls(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
