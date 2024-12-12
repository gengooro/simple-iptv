import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/data/date_utils.dart';
import 'package:iptv/data/function.dart';
import 'package:iptv/data/functions/stream_data.dart';
import 'package:iptv/database/xtream/streams/vod.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/models/streams/vod.dart';
import 'package:iptv/providers/metadata.dart';
import 'package:iptv/providers/recent_searches.dart';
import 'package:iptv/skeletons/vod_details.dart';
import 'package:iptv/widgets/dot_separated_text.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/widgets/flick_player/flick_player.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';

class VodDetailsPage extends StatefulWidget {
  final VodStreamModel stream;
  const VodDetailsPage({super.key, required this.stream});

  @override
  State<VodDetailsPage> createState() => _VodDetailsPageState();
}

class _VodDetailsPageState extends State<VodDetailsPage> {
  late final RecentWatchedProvider _recentChannelsProvider;

  @override
  void initState() {
    super.initState();
    _recentChannelsProvider =
        Provider.of<RecentWatchedProvider>(context, listen: false);

    // Add channel to recent list after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _recentChannelsProvider.addVod(widget.stream);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stream = widget.stream;

    return FutureBuilder(
      future: StreamData.getVod(
          widget.stream.streamId ?? "", widget.stream.tmdb ?? ""),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        if (isLoading) {
          // Return a skeleton loader while data is being fetched
          return const VodDetailsSkeleton();
        }

        if (snapshot.hasError) {
          // Show an error message if there is an error
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          // Handle cases where there is no data (unlikely for successful fetch)
          return const Center(child: Text('No data available'));
        }

        // Data has been successfully fetched
        final VodDataModel vodData = snapshot.data as VodDataModel;
        final tmdbData = vodData.tmdbVod;
        final vodDataServer = vodData.vodDataServer;

        if (vodData.vodDataServer?.movieData?.containerExtension == null) {
          return const Center(
            child: Text("No Video Found"),
          );
        }

        final url = Functions.getVodUrl(context, stream.streamId,
            vodData.vodDataServer?.movieData?.containerExtension ?? "");

        if (vodDataServer?.info is Map) {
          if ((vodDataServer?.info as List).isEmpty) {
            return Scaffold(
              backgroundColor: context.appColorScheme.surface,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: stream.streamIcon != null &&
                                stream.streamIcon!.isNotEmpty
                            ? Image.network(stream.streamIcon ?? "")
                            : Image.asset("assets/noimage1280x720.png"),
                      ),
                      VerticalGap(height: Constants.gap),
                      // Info
                      Container(
                        padding: EdgeInsets.all(2.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            if (stream.added != null &&
                                stream.added!.isNotEmpty)
                              Text(
                                DateFormat('yyyy-MM-dd').format(
                                    MyDateUtils.unixTimeToDateTime(
                                        int.tryParse(stream.added ?? "") ?? 0)),
                                style: context.appTextTheme.labelMedium,
                              ),
                            VerticalGap(height: Constants.gap / 2),
                            Text(
                              stream.name ?? Constants.notAvailableString,
                              style: context.appTextTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      VerticalGap(height: Constants.gap / 2),
                      const Divider(),
                      VerticalGap(height: Constants.gap / 2),
                      const Text("More Videos in this category"),
                      VerticalGap(height: Constants.gap / 2),
                      Expanded(
                        child: _buildChannelsList(),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }

        return Scaffold(
          backgroundColor: context.appColorScheme.surface,
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
                vertical: Constants.gap, horizontal: Constants.padding * 1.5),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (stream.trailer == null || stream.trailer!.isEmpty) {
                        final tmdbVideos = await StreamData.getTmdbVideos(
                            widget.stream.tmdb ?? "");

                        if (tmdbVideos.results != null &&
                            tmdbVideos.results!.isNotEmpty) {
                          Functions.launchYoutubeUrl(
                              tmdbVideos.results![0].key ?? "");
                        }
                      } else {
                        Functions.launchYoutubeUrl(stream.trailer ?? "");
                      }
                    },
                    icon: const Icon(BoxIcons.bxl_youtube),
                    label: const Text("Trailer"),
                  ),
                ),
                // SizedBox(width: Constants.gap),
                // if (vodData.vodDataServer?.movieData?.containerExtension !=
                //         null &&
                //     vodData.vodDataServer!.movieData!.containerExtension!
                //         .isNotEmpty)
                //   Expanded(
                //     child: ElevatedButton.icon(
                //       onPressed: () {
                //         if (vodData
                //                 .vodDataServer?.movieData?.containerExtension ==
                //             null) {
                //           return showSnackBar("No container extension found");
                //         }

                //         final url = Functions.getVodUrl(
                //             context,
                //             stream.streamId,
                //             vodData.vodDataServer?.movieData
                //                     ?.containerExtension ??
                //                 "");

                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             // builder: (context) => ChewiePlayer(
                //             //   url: url,
                //             //   format: VideoFormat.other,
                //             //   defaultFullscreen: true,
                //             // ),
                //             builder: (context) => FlickPlayer(
                //               url: url,
                //               videoFormat: VideoFormat.other,
                //               defaultFullscreen: true,
                //             ),
                //             // builder: (context) => PlayerWidget(
                //             //   url: url,
                //             //   videoFormat: BetterPlayerVideoFormat.other,
                //             //   defaultFullscreen: true,
                //             // ),
                //           ),
                //         );
                //       },
                //       icon: const Icon(Icons.play_arrow),
                //       label: const Text("Watch"),
                //     ),
                //   )
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(Constants.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Skeletonizer(
                          enabled: isLoading,
                          child: Stack(children: [
                            FlickPlayer(
                              url: url,
                              videoFormat: VideoFormat.other,
                              streamIcon: vodDataServer?.info?.movieImage,
                            ),
                            // AspectRatio(
                            //   aspectRatio: 16 / 9,
                            //   child: Image.network(
                            //       vodDataServer?.info?.movieImage ??
                            //           stream.streamIcon ??
                            //           Constants.notAvailableImage,
                            //       errorBuilder: (context, error, stackTrace) =>
                            //           const Icon(Icons.error,
                            //               color: Colors.red, size: 128)),
                            //   // child: vodData.vodDataServer?.info?.movieImage !=
                            //   //             null &&
                            //   //         vodData.vodDataServer!.info!.movieImage!
                            //   //             .isNotEmpty
                            //   //     ? Image.network(
                            //   //         Functions.getImdbImageUrl(vodData
                            //   //             .vodDataServer!.info!.movieImage!),
                            //   //         errorBuilder:
                            //   //             (context, error, stackTrace) {
                            //   //           return Image.asset(
                            //   //             "assets/noimage1280x720.png",
                            //   //           );
                            //   //         },
                            //   //       )
                            //   //     : Image.asset(
                            //   //         "assets/noimage1280x720.png",
                            //   //       ),
                            // ),
                            Positioned(
                              right: 7,
                              top: 7,
                              child: IconButton.filled(
                                onPressed: () {
                                  // TODO: Add to favorites Logic
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      context.appColorScheme.secondaryContainer,
                                ),
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: context
                                      .appColorScheme.onSecondaryContainer,
                                ),
                              ),
                            )
                          ])),
                    ),
                    VerticalGap(height: Constants.gap),
                    // Info
                    Container(
                      padding: EdgeInsets.all(2.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            vodDataServer?.info?.name ??
                                tmdbData?.title ??
                                stream.name ??
                                Constants.notAvailableString,
                            style: context.appTextTheme.titleMedium,
                          ),
                          VerticalGap(height: Constants.gap / 2),
                          // Release date
                          DotSeparatedTexts(
                            texts: [
                              Text(
                                vodDataServer?.info?.releasedate ??
                                    tmdbData?.releaseDate ??
                                    Constants.notAvailableString,
                                style: context.appTextTheme.labelMedium,
                              ),
                              if (vodDataServer?.info?.runtime != null &&
                                  vodDataServer!.info!.runtime!.isNotEmpty)
                                Text(
                                  MyDateUtils.minutesToTimeString(int.tryParse(
                                          vodDataServer.info?.runtime ?? "")) ??
                                      Constants.notAvailableString,
                                  style: context.appTextTheme.labelMedium,
                                ),
                              vodData.tmdbVod?.adult == true
                                  ? const Text("Adult")
                                  : const SizedBox(),
                            ],
                          ),
                          VerticalGap(height: Constants.gap / 2),
                          Text(
                            vodDataServer?.info?.genre ??
                                tmdbData?.genres
                                    ?.map((genre) => genre.name ?? "")
                                    .toList()
                                    .join(", ") ??
                                Constants.notAvailableString,
                            style: context.appTextTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                    VerticalGap(height: Constants.gap / 2),
                    if ((vodDataServer?.info?.plot != "" ||
                            vodDataServer!.info!.plot!.isNotEmpty) ||
                        (vodDataServer.info?.cast != "" ||
                            vodDataServer.info!.cast!.isNotEmpty))
                      Row(
                        children: [
                          if (vodDataServer?.info?.plot != null &&
                              vodDataServer?.info?.plot?.isNotEmpty == true)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Overview"),
                                        content: Text(
                                          (vodDataServer?.info?.plot
                                                          ?.trim()
                                                          .isEmpty ??
                                                      true
                                                  ? null
                                                  : vodDataServer
                                                      ?.info?.plot) ??
                                              (tmdbData?.overview
                                                          ?.trim()
                                                          .isEmpty ??
                                                      true
                                                  ? null
                                                  : tmdbData?.overview) ??
                                              Constants.notAvailableString,
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
                                  );
                                },
                                child: Container(
                                  height: 75.h,
                                  padding:
                                      EdgeInsets.all(Constants.padding / 3),
                                  decoration: BoxDecoration(
                                    color:
                                        context.appColorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Overview",
                                        style: context.appTextTheme.labelMedium,
                                      ),
                                      VerticalGap(height: Constants.gap / 2.5),
                                      Flexible(
                                        child: Text(
                                          vodDataServer?.info?.plot ??
                                              tmdbData?.overview ??
                                              Constants.notAvailableString,
                                          style:
                                              context.appTextTheme.labelMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          HorizontalGap(width: Constants.gap / 2),
                          if (vodDataServer?.info?.cast != null &&
                              vodDataServer?.info?.cast?.isNotEmpty == true)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Overview"),
                                        content: Text(
                                          vodData.tmdbVod?.overview ?? "",
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
                                  );
                                },
                                child: Container(
                                  height: 75.h,
                                  padding:
                                      EdgeInsets.all(Constants.padding / 3),
                                  decoration: BoxDecoration(
                                    color:
                                        context.appColorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cast",
                                        style: context.appTextTheme.labelMedium,
                                      ),
                                      VerticalGap(height: Constants.gap / 2.5),
                                      Flexible(
                                        child: Text(
                                          vodDataServer?.info?.cast ??
                                              Constants.notAvailableString,
                                          style:
                                              context.appTextTheme.labelMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    VerticalGap(height: Constants.gap / 2),
                    const Divider(),
                    VerticalGap(height: Constants.gap / 2),
                    const Text("More Videos in this category"),
                    VerticalGap(height: Constants.gap / 2),
                    Expanded(
                      child: _buildChannelsList(),
                    )
                  ],
                )),
          ),
        );
      },
    );
    // } else {
    // return Scaffold(
    //   backgroundColor: context.appColorScheme.surface,
    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: () {
    //       final url = Functions.getVodUrl(context, stream.streamId, "mp4");

    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => FlickPlayer(
    //             url: url,
    //             videoFormat: VideoFormat.other,
    //             defaultFullscreen: true,
    //           ),
    //         ),
    //       );
    //     },
    //     label: const Text("Play Now"),
    //     icon: const Icon(Icons.play_arrow),
    //   ),
    //   body: SafeArea(
    //     child: Padding(
    //       padding: EdgeInsets.all(Constants.padding),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // Cover
    //           AspectRatio(
    //             aspectRatio: 16 / 9,
    //             child:
    //                 stream.streamIcon != null && stream.streamIcon!.isNotEmpty
    //                     ? Image.network(stream.streamIcon ?? "")
    //                     : Image.asset("assets/noimage1280x720.png"),
    //           ),
    //           VerticalGap(height: Constants.gap),
    //           // Info
    //           Container(
    //             padding: EdgeInsets.all(2.r),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 // Title
    //                 if (stream.added != null && stream.added!.isNotEmpty)
    //                   Text(
    //                     DateFormat('yyyy-MM-dd').format(
    //                         MyDateUtils.unixTimeToDateTime(
    //                             int.tryParse(stream.added ?? "") ?? 0)),
    //                     style: context.appTextTheme.labelMedium,
    //                   ),
    //                 VerticalGap(height: Constants.gap / 2),
    //                 Text(
    //                   stream.name ?? "",
    //                   style: context.appTextTheme.titleMedium,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           VerticalGap(height: Constants.gap / 2),
    //           const Divider(),
    //           VerticalGap(height: Constants.gap / 2),
    //           const Text("More Videos in this category"),
    //           VerticalGap(height: Constants.gap / 2),
    //           Expanded(
    //             child: _buildChannelsList(),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    // }
  }

  Widget _buildChannelsList() {
    return Consumer<MetaDataProvider>(
      builder: (context, metaData, _) {
        var categoryStreams = metaData.vodStreams
            .where((stream) => stream.categoryId == widget.stream.categoryId)
            .toList();

// Remove the stream that matches widget.stream by name
        categoryStreams
            .removeWhere((stream) => stream.name == widget.stream.name);

        categoryStreams.shuffle();

        return ListView.separated(
          separatorBuilder: (_, __) => VerticalGap(height: 7.h),
          itemCount: categoryStreams.length,
          itemBuilder: (context, index) =>
              _buildChannelTile(categoryStreams[index]),
        );
      },
    );
  }

  Widget _buildChannelTile(VodStreamModel stream) {
    return MyListTile(
      title: stream.name ?? "",
      iconUrl: stream.streamIcon,
      onTap: () => _navigateToChannel(stream),
    );
  }

  void _navigateToChannel(VodStreamModel stream) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VodDetailsPage(
          stream: stream,
        ),
      ),
    );
  }
}
