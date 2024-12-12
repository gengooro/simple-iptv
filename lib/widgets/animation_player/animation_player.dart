import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:iptv/widgets/animation_player/portrait_video_controls.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

import 'data_manager.dart';
import 'landscape_controls.dart';

class AnimationPlayer extends StatefulWidget {
  const AnimationPlayer({super.key});

  @override
  _AnimationPlayerState createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer> {
  late FlickManager flickManager;
  late AnimationPlayerDataManager dataManager;
  bool _pauseOnTap = true;
  double playBackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    // String url = items[0]['trailer_url'];
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(
            "http://cf.gocdn8k.me:80/movie/iptvflag7o3/7thi8mdmrj/1201842.mkv"),
        formatHint: VideoFormat.other,
      ),
      onVideoEnd: () => dataManager.playNextVideo(
        Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager!.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager!.autoResume();
        }
      },
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: FlickVideoPlayer(
                  flickManager: flickManager,
                  flickVideoWithControls: AnimationPlayerPortraitVideoControls(
                      pauseOnTap: _pauseOnTap),
                  flickVideoWithControlsFullscreen: FlickVideoWithControls(
                    controls: AnimationPlayerLandscapeControls(),
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('Next video'),
                onPressed: () => dataManager.playNextVideo(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('On tap action -- '),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _pauseOnTap = true;
                            });
                          },
                          child: Text('Pause')),
                      Switch(
                        value: !_pauseOnTap,
                        onChanged: (value) {
                          setState(() {
                            _pauseOnTap = !value;
                          });
                        },
                        activeColor: Colors.red,
                        inactiveThumbColor: Colors.blue,
                        inactiveTrackColor: Colors.blue[200],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pauseOnTap = false;
                          });
                        },
                        child: Text(
                          'Mute',
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Playback speed -- '),
                  Row(
                    children: [
                      Slider(
                        value: playBackSpeed,
                        onChanged: (val) {},
                        onChangeEnd: (val) {
                          flickManager.flickVideoManager?.videoPlayerController!
                              .setPlaybackSpeed(val);
                          setState(() {
                            playBackSpeed = val;
                          });
                        },
                        min: 0.25,
                        max: 2,
                      ),
                      Text(playBackSpeed.toStringAsFixed(2).toString()),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
