import 'package:flutter/material.dart';
import 'package:iptv/controllers/metadata.dart';
import 'package:iptv/controllers/selected_account.dart';
import 'package:iptv/data/function.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:iptv/database/xtream/streams/live.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/widgets/media_tab_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/widgets/player/live_tv_player.dart'; // Keep only this import for LiveTvBetterPlayer
import 'package:iptv/widgets/search/live_tv.dart';
import 'package:provider/provider.dart';

class LiveTvTab extends StatefulWidget {
  const LiveTvTab({super.key});

  @override
  State<LiveTvTab> createState() => _LiveTvTabState();
}

class _LiveTvTabState extends State<LiveTvTab> {
  late MetaDataProvider metaDataProvider;
  late SelectedAccountProvider selectedAccountProvider;
  List<CategoryModel> liveCategories = [];
  List<LiveStreamModel> liveChannels = [];

  @override
  void initState() {
    super.initState();
    selectedAccountProvider =
        Provider.of<SelectedAccountProvider>(context, listen: false);
    metaDataProvider = Provider.of<MetaDataProvider>(context, listen: false);
    liveCategories = metaDataProvider.getLiveCategories()
      ..sort((a, b) => (a.categoryName ?? "").compareTo(b.categoryName ?? ""));
    liveChannels = metaDataProvider.liveStreams
      ..sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return MediaTabBase(
      categories: liveCategories,
      streams: liveChannels,
      getCategoryId: (stream) => (stream as LiveStreamModel).categoryId ?? "",
      getSelectedCategoryId: (provider) => provider.categoryTabLiveTvId,
      setSelectedCategory: (provider, id) => provider.setCategoryTabLiveTv(id),
      searchTag: 'live',
      onSearchTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LiveTvSearch(searchTag: 'live'),
          )),
      listBuilder: (context, filteredStreams) {
        return ListView.separated(
          itemCount: filteredStreams.length,
          separatorBuilder: (context, index) {
            return VerticalGap(
              height: 7.h,
            );
          },
          itemBuilder: (context, index) {
            final channel = filteredStreams[index] as LiveStreamModel;

            return MyListTile(
              title: channel.name ?? "",
              iconUrl: channel.streamIcon,
              onTap: () {
                final url = Functions.getHLSUrl(context, channel.streamId ?? 0);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LiveTvPlayer(url: url, channel: channel),
                  ),
                );
              },
            );
          },
        );
        // return GridView.builder(
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 4,
        //     mainAxisSpacing: 5.sp,
        //     crossAxisSpacing: 5.sp,
        //   ),
        //   itemCount: filteredStreams.length,
        //   itemBuilder: (context, index) {
        //     final channel = filteredStreams[index] as LiveStreamModel;
        //     return GestureDetector(
        //       onTap: () {
        //         final url = Functions.getHLSUrl(context, channel.streamId ?? 0);
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => LiveTvPlayer(url: url),
        //           ),
        //         );
        //       },
        //       child: Container(
        //         padding: EdgeInsets.all(4.r),
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             width: 1.r,
        //           ),
        //           borderRadius: BorderRadius.circular(4.r),
        //         ),
        //         child: GridTile(
        //           child: channel.streamIcon?.isEmpty ?? true
        //               ? Image.asset("assets/noimage.jpg")
        //               : Image.network(
        //                   channel.streamIcon ?? "",
        //                   fit: BoxFit.fill,
        //                 ),
        //         ),
        //       ),
        //     );
        //   },
        // );
      },
    );
  }
}
