import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  final String url;
  final BetterPlayerVideoFormat videoFormat;
  final BetterPlayerConfiguration? configuration;
  final BetterPlayerController? controller;
  final bool isLive;
  final bool defaultFullscreen;

  const PlayerWidget({
    super.key,
    required this.url,
    required this.videoFormat,
    this.configuration,
    this.controller,
    this.isLive = false,
    this.defaultFullscreen = false,
  });

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late final BetterPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    // Initialize the player controller
    _playerController = widget.controller ?? _initializeController();
    _playerController.setupDataSource(_createDataSource());
    // Manually set the player to fullscreen as soon as it initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.defaultFullscreen) {
        _playerController.enterFullScreen();
      }
    });
  }

  BetterPlayerController _initializeController() {
    return BetterPlayerController(
      widget.configuration ?? _defaultConfiguration(),
    );
  }

  BetterPlayerConfiguration _defaultConfiguration() {
    return const BetterPlayerConfiguration(
      autoPlay: true,
      looping: false,
      autoDetectFullscreenAspectRatio: true,
      autoDetectFullscreenDeviceOrientation: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enablePlayPause: true,
        enableRetry: true,
        enableMute: true,
        enablePip: true,
        enableSkips: true,
        enablePlaybackSpeed: true,
        enableFullscreen: true,
        enableProgressBar: true,
        loadingWidget: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  BetterPlayerDataSource _createDataSource() {
    return BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      videoFormat: widget.videoFormat,
      liveStream: widget.isLive,
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 5000,
        maxBufferMs: 131072,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,
        preCacheSize: 3 * 1024 * 1024,
      ),

      // bufferingConfiguration: const BetterPlayerBufferingConfiguration(
      //   minBufferMs: 5000,
      //   maxBufferMs: 131072,
      //   bufferForPlaybackMs: 2500,
      //   bufferForPlaybackAfterRebufferMs: 5000,
      // ),
      // cacheConfiguration: const BetterPlayerCacheConfiguration(
      //   useCache: true,
      //   maxCacheSize: 10 * 1024 * 1024,
      //   maxCacheFileSize: 10 * 1024 * 1024,
      //   preCacheSize: 3 * 1024 * 1024,
      // ),
      useAsmsSubtitles: true,
      headers: const {
        "User-Agent":
            "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Mobile Safari/537.36",
      },
    );
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.defaultFullscreen == true
          ? MediaQuery.of(context).size.aspectRatio
          : 16 / 9, // Take up full screen
      child: BetterPlayer(
        controller: _playerController,
      ),
    );
  }
}
