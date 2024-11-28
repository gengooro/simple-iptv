import 'package:flutter/material.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/providers/metadata.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:iptv/database/xtream/streams/vod.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/widgets/media_tab_base.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/widgets/player/vod/page.dart';
import 'package:iptv/widgets/search/vod.dart';
import 'package:provider/provider.dart';

class VodTab extends StatefulWidget {
  const VodTab({super.key});

  @override
  State<VodTab> createState() => _VodTabState();
}

class _VodTabState extends State<VodTab> {
  late MetaDataProvider metaDataProvider;
  List<CategoryModel> vodCategories = [];
  List<VodStreamModel> vodStreams = [];

  @override
  void initState() {
    super.initState();
    metaDataProvider = Provider.of<MetaDataProvider>(context, listen: false);
    vodCategories = metaDataProvider.getVodCategories();
    vodStreams = metaDataProvider.vodStreams;
  }

  @override
  Widget build(BuildContext context) {
    return MediaTabBase(
      categories: vodCategories,
      streams: vodStreams,
      getCategoryId: (stream) => (stream as VodStreamModel).categoryId ?? "",
      getSelectedCategoryId: (provider) => provider.categoryTabVodId,
      setSelectedCategory: (provider, id) => provider.setCategoryTabVod(id),
      searchTag: 'vod',
      onSearchTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VodSearch(searchTag: 'vod'),
          )),
      listBuilder: (context, filteredStreams) {
        return ListView.separated(
          separatorBuilder: (context, index) {
            return VerticalGap(
              height: Constants.gap,
            );
          },
          itemCount: filteredStreams.length,
          itemBuilder: (context, index) {
            final vod = filteredStreams[index] as VodStreamModel;

            return MyListTile(
              title: vod.name ?? "",
              iconUrl: vod.streamIcon,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VodDetailsPage(
                      stream: vod,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
