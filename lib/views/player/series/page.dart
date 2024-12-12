import 'package:flutter/material.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/data/function.dart';
import 'package:iptv/data/functions/stream_data.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/models/streams/series.dart';
import 'package:iptv/providers/recent_searches.dart';
import 'package:iptv/skeletons/series_details.dart';
import 'package:iptv/widgets/customtabbar/custom_tabbar.dart';
import 'package:iptv/widgets/dot_separated_text.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/widgets/flick_player/flick_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SeriesDetailsSkeleton();
                }

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
                    // Cover
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              seriesData.info?.cover != null &&
                                      seriesData.info!.cover!.isNotEmpty
                                  ? Image.network(
                                      Functions.replaceImageSize(
                                          seriesData.info?.cover ?? ""),
                                    )
                                  : Image.asset(
                                      "assets/noimage1280x720.png",
                                    ),
                              Positioned(
                                right: 7,
                                top: 7,
                                child: IconButton.filled(
                                  onPressed: () {
                                    // TODO: Add to favorites Logic
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: context
                                        .appColorScheme.secondaryContainer,
                                  ),
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: context
                                        .appColorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    VerticalGap(height: Constants.gap / 2),
                    // Details
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seriesData.info?.name ?? "",
                            style: context.appTextTheme.titleSmall,
                          ),
                          VerticalGap(height: Constants.gap / 3),
                          DotSeparatedTexts(
                            texts: [
                              if (seriesData.info?.releaseDate != null &&
                                  seriesData.info!.releaseDate!.isNotEmpty)
                                Text(
                                  seriesData.info!.releaseDate!,
                                  style: context.appTextTheme.labelMedium,
                                ),
                              if (seriesData.seasons != null &&
                                  seriesData.seasons!.isNotEmpty)
                                Text(
                                  "${seriesData.seasons!.length.toString()} Seasons",
                                  style: context.appTextTheme.labelMedium,
                                ),
                              if (seriesData.episodes != null &&
                                  seriesData.episodes!.isNotEmpty)
                                Text(
                                  "${seriesData.episodes!.length.toString()} Episodes",
                                  style: context.appTextTheme.labelMedium,
                                ),
                            ],
                          ),
                          if (seriesData.info?.genre != null &&
                              seriesData.info!.genre!.isNotEmpty)
                            Text(
                              seriesData.info!.genre!,
                              style: context.appTextTheme.bodySmall,
                            ),
                          VerticalGap(height: Constants.gap / 2),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Overview"),
                                        content: Text(
                                          seriesData.info?.plot ?? "",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  child: Container(
                                    height: 75.h,
                                    padding:
                                        EdgeInsets.all(Constants.padding / 3),
                                    decoration: BoxDecoration(
                                      color: context
                                          .appColorScheme.surfaceContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Overview",
                                          style:
                                              context.appTextTheme.labelMedium,
                                        ),
                                        VerticalGap(
                                            height: Constants.gap / 2.5),
                                        Flexible(
                                          child: Text(
                                            seriesData.info?.plot ?? "",
                                            style: context
                                                .appTextTheme.labelMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              HorizontalGap(width: Constants.gap),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Cast"),
                                        content: Text(
                                          seriesData.info?.cast ?? "",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  child: Container(
                                    height: 75.h,
                                    padding:
                                        EdgeInsets.all(Constants.padding / 3),
                                    decoration: BoxDecoration(
                                      color: context
                                          .appColorScheme.surfaceContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cast",
                                          style:
                                              context.appTextTheme.labelMedium,
                                        ),
                                        VerticalGap(
                                            height: Constants.gap / 2.5),
                                        Flexible(
                                          child: Text(
                                            seriesData.info?.cast ?? "",
                                            style: context
                                                .appTextTheme.labelMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Cover
                    // Container(
                    //   clipBehavior: Clip.hardEdge,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.rectangle,
                    //     color: context.appColorScheme.surfaceContainer,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         child: seriesData.info?.cover != null &&
                    //                 seriesData.info!.cover!.isNotEmpty
                    //             ? Image.network(
                    //                 Functions.getImdbImageUrl(
                    //                     seriesData.info?.cover ?? ""),
                    //                 width: context.mediaQuery.size.width / 3,
                    //                 errorBuilder: (context, error, stackTrace) {
                    //                   // Show the placeholder image when the network image fails to load
                    //                   return Image.asset(
                    //                     "assets/noimage.jpg",
                    //                     scale: 0.5,
                    //                     width:
                    //                         context.mediaQuery.size.width / 3,
                    //                   );
                    //                 },
                    //               )
                    //             : Image.asset(
                    //                 "assets/noimage.jpg",
                    //                 scale: 0.5,
                    //                 width: context.mediaQuery.size.width / 3,
                    //               ),
                    //       ),
                    //       HorizontalGap(
                    //         width: Constants.gap / 2,
                    //       ),
                    //       Expanded(
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: Constants.padding / 3),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.center,
                    //                 children: [
                    //                   if (seriesData.info?.releaseDate !=
                    //                           null &&
                    //                       seriesData
                    //                           .info!.releaseDate!.isNotEmpty)
                    //                     Text(
                    //                       seriesData.info?.releaseDate ?? "",
                    //                       style:
                    //                           context.appTextTheme.labelMedium,
                    //                     ),
                    //                   if (seriesData.info?.rating5Based !=
                    //                           null &&
                    //                       seriesData
                    //                           .info!.rating5Based!.isNotEmpty)
                    //                     StarRating(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.start,
                    //                       rating: double.tryParse(
                    //                               widget.series.rating5based ??
                    //                                   "") ??
                    //                           0,
                    //                       starCount: 5,
                    //                       size: 14.sp,
                    //                       borderColor: Colors.black,
                    //                     )
                    //                 ],
                    //               ),
                    //               Text(
                    //                 widget.series.name ?? "",
                    //                 style: context.appTextTheme.titleSmall,
                    //               ),
                    //               widget.series.genre != null &&
                    //                       widget.series.genre!.isNotEmpty
                    //                   ? GestureDetector(
                    //                       onTap: () {
                    //                         showDialog(
                    //                           context: context,
                    //                           builder: (context) {
                    //                             return AlertDialog(
                    //                               title: const Text("Genre"),
                    //                               content: Text(
                    //                                   widget.series.genre ??
                    //                                       ""),
                    //                               actions: [
                    //                                 TextButton(
                    //                                   onPressed: () {
                    //                                     Navigator.pop(context);
                    //                                   },
                    //                                   child:
                    //                                       const Text('Close'),
                    //                                 ),
                    //                               ],
                    //                             );
                    //                           },
                    //                         );
                    //                       },
                    //                       child: Text(
                    //                         Functions.cropText(
                    //                             widget.series.genre ?? "", 26),
                    //                         style:
                    //                             context.appTextTheme.bodySmall,
                    //                       ),
                    //                     )
                    //                   : const SizedBox(),
                    //               VerticalGap(height: 4.h),
                    //               widget.series.cast != null &&
                    //                       widget.series.cast!.isNotEmpty
                    //                   ? GestureDetector(
                    //                       onTap: () {
                    //                         showDialog(
                    //                           context: context,
                    //                           builder: (context) {
                    //                             return AlertDialog(
                    //                               title: const Text("Cast"),
                    //                               content: Text(
                    //                                   widget.series.cast ?? ""),
                    //                               actions: [
                    //                                 TextButton(
                    //                                   onPressed: () {
                    //                                     Navigator.pop(context);
                    //                                   },
                    //                                   child:
                    //                                       const Text('Close'),
                    //                                 ),
                    //                               ],
                    //                             );
                    //                           },
                    //                         );
                    //                       },
                    //                       child: Text(
                    //                         Functions.cropText(
                    //                           widget.series.cast ?? "",
                    //                           50,
                    //                         ),
                    //                         style:
                    //                             context.appTextTheme.bodySmall,
                    //                       ),
                    //                     )
                    //                   : const SizedBox(),
                    //               VerticalGap(height: 4.h),
                    //               widget.series.plot != null &&
                    //                       widget.series.plot!.isNotEmpty
                    //                   ? GestureDetector(
                    //                       onTap: () {
                    //                         showDialog(
                    //                           context: context,
                    //                           builder: (context) {
                    //                             return AlertDialog(
                    //                               title: const Text("Plot"),
                    //                               content: Text(
                    //                                   widget.series.plot ?? ""),
                    //                               actions: [
                    //                                 TextButton(
                    //                                   onPressed: () {
                    //                                     Navigator.pop(context);
                    //                                   },
                    //                                   child:
                    //                                       const Text('Close'),
                    //                                 ),
                    //                               ],
                    //                             );
                    //                           },
                    //                         );
                    //                       },
                    //                       child: Text(
                    //                         Functions.cropText(
                    //                           widget.series.plot ?? "",
                    //                           50,
                    //                         ),
                    //                         style:
                    //                             context.appTextTheme.bodySmall,
                    //                       ),
                    //                     )
                    //                   : const SizedBox(),
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    VerticalGap(
                      height: 8.h,
                    ),
                    Expanded(
                        child: CustomTabBar(
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
                                    MaterialPageRoute(builder: (context) {
                                      final url = Functions.getSeriesEpisodeUrl(
                                          context,
                                          episode.id,
                                          episode.containerExtension);

                                      return FlickPlayer(
                                        url: url,
                                        videoFormat: VideoFormat.other,
                                        defaultFullscreen: true,
                                      );
                                      // return PlayerWidget(
                                      //   url: url,
                                      //   videoFormat:
                                      //       BetterPlayerVideoFormat.other,
                                      //   defaultFullscreen: true,
                                      // );
                                    }),
                                  );
                                },
                                title: episode.title,
                                subtitle: "Episode ${episode.episodeNum}",
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
