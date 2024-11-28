import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/data/function.dart';
import 'package:iptv/data/functions/stream_data.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/extension/helper.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/models/streams/series.dart';
import 'package:iptv/providers/recent_searches.dart';
import 'package:iptv/widgets/customtabbar/custom_tabbar.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/widgets/player/player.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SeriesDetailsPage extends StatefulWidget {
  final SeriesStreamModel series;
  const SeriesDetailsPage({super.key, required this.series});

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
  late final RecentWatchedProvider _recentChannelsProvider;

  @override
  void initState() {
    super.initState();
    _recentChannelsProvider =
        Provider.of<RecentWatchedProvider>(context, listen: false);

    // Add channel to recent list after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _recentChannelsProvider.addSeries(widget.series);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constants.padding),
          child: FutureBuilder(
              future: StreamData.getSeries(widget.series.seriesId ?? ""),
              builder: (context, snapshot) {
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting;

                SeriesData seriesData =
                    SeriesData(); // Initialize with a default value
                Map<int, List<Episode>> episodes =
                    {}; // Initialize with an empty map

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  seriesData = snapshot.data as SeriesData;
                  episodes = seriesData.episodes ?? {};
                }

                return Column(
                  children: [
                    Image.network(
                      Functions.getImdbImageUrl(
                          seriesData.info?.backdropPath?[0] ?? ""),
                      width: context.mediaQuery.size.width / 3,
                      errorBuilder: (context, error, stackTrace) {
                        // Show the placeholder image when the network image fails to load
                        return Image.asset(
                          "assets/noimage.jpg",
                          scale: 0.5,
                          width: context.mediaQuery.size.width / 3,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Skeletonizer(
                            enabled: isLoading, child: const SizedBox());
                      },
                    ),
                    // Cover
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: context.appColorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: seriesData.info?.cover != null &&
                                    seriesData.info!.cover!.isNotEmpty
                                ? Image.network(
                                    Functions.getImdbImageUrl(
                                        seriesData.info?.cover ?? ""),
                                    width: context.mediaQuery.size.width / 3,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Show the placeholder image when the network image fails to load
                                      return Image.asset(
                                        "assets/noimage.jpg",
                                        scale: 0.5,
                                        width:
                                            context.mediaQuery.size.width / 3,
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Skeletonizer(
                                          enabled: isLoading,
                                          child: const SizedBox());
                                    },
                                  )
                                : Image.asset(
                                    "assets/noimage.jpg",
                                    scale: 0.5,
                                    width: context.mediaQuery.size.width / 3,
                                  ),
                          ),
                          HorizontalGap(
                            width: Constants.gap / 2,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Constants.padding / 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Skeletonizer(
                                          enabled: isLoading,
                                          child: seriesData.info?.releaseDate !=
                                                  null
                                              ? Text(
                                                  seriesData
                                                          .info?.releaseDate ??
                                                      "",
                                                  style: context
                                                      .appTextTheme.labelMedium,
                                                )
                                              : const SizedBox()),
                                      Skeletonizer(
                                          enabled: isLoading,
                                          child: seriesData
                                                      .info?.rating5Based !=
                                                  null
                                              ? StarRating(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  rating: double.tryParse(widget
                                                              .series
                                                              .rating5based ??
                                                          "") ??
                                                      0,
                                                  starCount: 5,
                                                  size: 14.sp,
                                                  borderColor: Colors.black,
                                                )
                                              : const SizedBox()),
                                    ],
                                  ),
                                  Text(
                                    widget.series.name ?? "",
                                    style: context.appTextTheme.titleSmall,
                                  ),
                                  widget.series.genre != null &&
                                          widget.series.genre!.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Genre"),
                                                  content: Text(
                                                      widget.series.genre ??
                                                          ""),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            Functions.cropText(
                                                widget.series.genre ?? "", 26),
                                            style:
                                                context.appTextTheme.bodySmall,
                                          ),
                                        )
                                      : const SizedBox(),
                                  VerticalGap(height: 4.h),
                                  widget.series.cast != null &&
                                          widget.series.cast!.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Cast"),
                                                  content: Text(
                                                      widget.series.cast ?? ""),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            Functions.cropText(
                                              widget.series.cast ?? "",
                                              50,
                                            ),
                                            style:
                                                context.appTextTheme.bodySmall,
                                          ),
                                        )
                                      : const SizedBox(),
                                  VerticalGap(height: 4.h),
                                  widget.series.plot != null &&
                                          widget.series.plot!.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Plot"),
                                                  content: Text(
                                                      widget.series.plot ?? ""),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            Functions.cropText(
                                              widget.series.plot ?? "",
                                              50,
                                            ),
                                            style:
                                                context.appTextTheme.bodySmall,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    VerticalGap(
                      height: 8.h,
                    ),
                    Expanded(
                        child: isLoading
                            ? Skeletonizer(
                                enabled: isLoading,
                                child: ListView.builder(
                                  itemCount: 7,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Material(
                                        child: ListTile(
                                          title: Text(
                                              'Item number $index as title'),
                                          subtitle: const Text('Subtitle here'),
                                          trailing: const Icon(Icons.ac_unit),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : CustomTabBar(
                                tabs: episodes.keys.map((season) {
                                  return "Season $season";
                                }).toList(),
                                views: episodes.entries.map((entry) {
                                  final episodesList = entry.value;

                                  return ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return VerticalGap(
                                        height: Constants.gap,
                                      );
                                    },
                                    itemCount: episodesList.length,
                                    itemBuilder: (context, index) {
                                      final episode = episodesList[index];

                                      return Material(
                                        child: MyListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                final url = Functions
                                                    .getSeriesEpisodeUrl(
                                                        context,
                                                        episode.id,
                                                        episode
                                                            .containerExtension);

                                                return PlayerWidget(
                                                  url: url,
                                                  videoFormat:
                                                      BetterPlayerVideoFormat
                                                          .other,
                                                  defaultFullscreen: true,
                                                );
                                              }),
                                            );
                                          },
                                          title: episode.title,
                                          subtitle:
                                              "Episode ${episode.episodeNum}",
                                          iconUrl: seriesData.info?.cover,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              )),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
