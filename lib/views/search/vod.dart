import 'package:flutter/material.dart';
import 'package:iptv/database/xtream/streams/vod.dart';
import 'package:iptv/providers/metadata.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/providers/recent_searches.dart';
import 'package:iptv/providers/search_items.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/views/player/vod/page.dart';
import 'package:iptv/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VodSearch extends StatefulWidget {
  final String? searchTag;
  const VodSearch({super.key, this.searchTag});

  @override
  State<VodSearch> createState() => _VodSearchState();
}

class _VodSearchState extends State<VodSearch> {
  final TextEditingController _searchController = TextEditingController();
  late final FocusNode focusNode;
  late MetaDataProvider metaDataProvider;
  late RecentWatchedProvider recentWatchedProvider;
  List<VodStreamModel> allStreams = [];

  String searchText = "";

  @override
  void initState() {
    super.initState(); // Move super.initState() to the top
    focusNode = FocusNode();

    // Remove the cast, just use context directly
    metaDataProvider = Provider.of<MetaDataProvider>(context, listen: false);
    allStreams = metaDataProvider.vodStreams;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && focusNode.canRequestFocus) {
            focusNode.requestFocus();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constants.padding),
          child: Column(
            children: [
              Hero(
                tag: '${widget.searchTag}',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Consumer<SearchItemsProvider>(
                builder: (context, searchItemsProvider, child) {
                  return SearchTextfield(
                    autofocus: true,
                    focusNode: focusNode,
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                      if (value.isNotEmpty) {
                        final streams = allStreams
                            .where((stream) =>
                                stream.name
                                    ?.toLowerCase()
                                    .contains(value.toLowerCase()) ??
                                false)
                            .toList();
                        searchItemsProvider.vodItems = streams;
                      } else {
                        searchItemsProvider.vodItems = [];
                      }
                    },
                  );
                },
              ),
              const Divider(),
              // Content area
              Expanded(
                child: searchText == ""
                    ? Consumer<RecentWatchedProvider>(
                        builder: (context, recentWatchedProvider, child) {
                          final vodStreams =
                              recentWatchedProvider.vod.reversed.toList();
                          return vodStreams.isEmpty
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Recently viewed",
                                          style:
                                              context.appTextTheme.bodyMedium,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            recentWatchedProvider.clearVod();
                                          },
                                          child: Text(
                                            "Clear",
                                            style:
                                                context.appTextTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return VerticalGap(height: 7.h);
                                        },
                                        itemCount: vodStreams.length,
                                        itemBuilder: (context, index) {
                                          final stream = vodStreams[index];
                                          return Consumer<
                                                  RecentWatchedProvider>(
                                              builder: (context,
                                                  recentWatchedProvider,
                                                  child) {
                                            return MyListTile(
                                              title: stream.name ?? "",
                                              iconUrl: stream.streamIcon,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VodDetailsPage(
                                                      stream: stream,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                        },
                      )
                    : Consumer<SearchItemsProvider>(
                        builder: (context, value, child) {
                          final vodStreams = value.vodItems;
                          return vodStreams.isEmpty
                              ? const Center(child: Text('Search something'))
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return VerticalGap(height: 7.h);
                                  },
                                  itemCount: vodStreams.length,
                                  itemBuilder: (context, index) {
                                    final vodStream = vodStreams[index];

                                    return RepaintBoundary(
                                      child: Consumer<RecentWatchedProvider>(
                                        builder: (context,
                                            recentWatchedProvider, child) {
                                          return MyListTile(
                                            title: vodStream.name ?? "",
                                            iconUrl: vodStream.streamIcon,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VodDetailsPage(
                                                    stream: vodStream,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
