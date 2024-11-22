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

class LiveTvPlayer extends StatefulWidget {
  final String url;
  final LiveStreamModel channel;

  const LiveTvPlayer({super.key, required this.url, required this.channel});

  @override
  State<LiveTvPlayer> createState() => _LiveTvPlayerState();
}

class _LiveTvPlayerState extends State<LiveTvPlayer> {
  late BetterPlayerController _betterPlayerController;
  late RecentWatchedChannelsProvider _recentWatchedChannelsProvider;
  bool _hasError = false;

  // double _currentAspectRatio = 16 / 9;
  // final List<double> _aspectRatios = [
  //   16 / 9, // Widescreen
  //   4 / 3, // Standard
  //   21 / 9, // Ultra-wide
  // ];

  // final List<String> _aspectLabels = ['16:9', '4:3', '21:9'];

  // void _toggleAspectRatio() {
  //   setState(() {
  //     int currentIndex = _aspectRatios.indexOf(_currentAspectRatio);
  //     int nextIndex = (currentIndex + 1) % _aspectRatios.length;
  //     _currentAspectRatio = _aspectRatios[nextIndex];
  //     _betterPlayerController.setControlsEnabled(true);
  //     _betterPlayerController.setOverriddenAspectRatio(_currentAspectRatio);
  //   });
  // }

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
        enableProgressBar: false,
        enableProgressText: false,
        enablePlaybackSpeed: false,
        enableSkips: false,
        enableOverflowMenu: false,
        showControlsOnInitialize: true,
        enablePip: true,
        loadingColor: Colors.white,
        playerTheme: BetterPlayerTheme.material,
        controlBarColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(106, 0, 0, 0),
        enableFullscreen: true,
        liveTextColor: Colors.transparent,
        enablePlayPause: true,
        controlBarHeight: 30,
        loadingWidget: const Center(
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
      liveStream: true,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recentWatchedChannelsProvider =
          Provider.of<RecentWatchedChannelsProvider>(context, listen: false);
      _recentWatchedChannelsProvider.addLiveTv(widget.channel);
    });
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
    final channel = widget.channel;

    return Scaffold(
      backgroundColor: context.appColorScheme.surface,
      body: SafeArea(
        child: _hasError
            ? Column(
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
              )
            : Padding(
                padding: EdgeInsets.all(Constants.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: context.appColorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: context.appColorScheme.surface,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: BetterPlayer(
                                controller: _betterPlayerController,
                              ),
                            ),
                          ),
                          VerticalGap(
                            height: 7.h,
                          ),
                          Text(
                            channel.name ?? "",
                            style: context.appTextTheme.displaySmall,
                          ),
                          const Divider(),
                          const Text("More Channels in this category"),
                          VerticalGap(
                            height: 4.h,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Consumer<MetaDataProvider>(
                          builder: (context, value, child) {
                        final streams = value.liveStreams;

                        final thisCategory = streams
                            .where((stream) =>
                                stream.categoryId == channel.categoryId)
                            .toList();

                        return ListView.separated(
                            separatorBuilder: (context, index) =>
                                VerticalGap(height: 7.h),
                            itemCount: thisCategory.length,
                            itemBuilder: (context, index) {
                              final stream = thisCategory[index];
                              return MyListTile(
                                  title: stream.name ?? "",
                                  iconUrl: stream.streamIcon,
                                  onTap: () {
                                    _betterPlayerController.pause();
                                    _betterPlayerController.dispose();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LiveTvPlayer(
                                          url: Functions.getHLSUrl(
                                              context, stream.streamId),
                                          channel: stream,
                                        ),
                                      ),
                                    );
                                  });
                            });
                      }),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
