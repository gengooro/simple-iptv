import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:iptv/controllers/metadata.dart';
import 'package:iptv/data/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/data/function.dart';
import 'package:iptv/database/xtream/streams/live.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/provider/recent_searches.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/widgets/player/custom_controls.dart';
import 'package:provider/provider.dart';

class IPTVVideoPlayer extends StatefulWidget {
  final String url;
  final bool isLive;
  final double aspectRatio;

  const IPTVVideoPlayer({
    super.key,
    required this.url,
    this.isLive = true,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<IPTVVideoPlayer> createState() => _IPTVVideoPlayerState();
}

class _IPTVVideoPlayerState extends State<IPTVVideoPlayer> {
  late BetterPlayerController _betterPlayerController;
  bool _hasError = false;

  void _setupPlayer() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoPlay: true,
      looping: true,
      handleLifecycle: false,
      autoDetectFullscreenAspectRatio: true,
      autoDetectFullscreenDeviceOrientation: true,
      autoDispose: true,
      useRootNavigator: true,
      playerVisibilityChangedBehavior: onVisibilityChanged,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        customControlsBuilder: (controller, onPlayerVisibilityChanged) =>
            CustomControlsWidget(
                controller: controller,
                onControlsVisibilityChanged: onPlayerVisibilityChanged),
        showControls: true,
        enableProgressBar: !widget.isLive,
        enableProgressText: !widget.isLive,
        enablePlaybackSpeed: !widget.isLive,
        enableSkips: !widget.isLive,
        enableOverflowMenu: false,
        showControlsOnInitialize: true,
        enablePip: true,
        loadingColor: Colors.white,
        playerTheme: BetterPlayerTheme.material,
        controlBarColor: Colors.transparent,
        backgroundColor: Color.fromARGB(106, 0, 0, 0),
        enableFullscreen: true,
        liveTextColor: Colors.transparent,
        enablePlayPause: true,
        controlBarHeight: 30,
        loadingWidget: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      videoFormat: BetterPlayerVideoFormat.other,
      notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: false,
        title: "Playing video",
        author: "IPTV",
      ),
      liveStream: widget.isLive,
      headers: const {
        "User-Agent":
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
      },
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener(_onPlayerEvent);
    _betterPlayerController.setupDataSource(dataSource);
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _retryPlayback() {
    setState(() {
      _hasError = false;
    });
    _betterPlayerController.dispose();
    _setupPlayer();
  }

  void onVisibilityChanged(double visibilityFraction) {
    if (visibilityFraction == 0 && mounted) {
      _betterPlayerController.pause();
    } else if (visibilityFraction == 1 && mounted) {
      _betterPlayerController.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupPlayer();
  }

  @override
  void dispose() {
    _betterPlayerController.removeEventsListener(_onPlayerEvent);
    _betterPlayerController.pause();
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Something went wrong',
              style: context.appTextTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryPlayback,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.appColorScheme.surface,
      ),
      clipBehavior: Clip.hardEdge,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
      ),
    );
  }
}
