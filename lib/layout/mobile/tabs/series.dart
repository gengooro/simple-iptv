import 'package:flutter/material.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/providers/metadata.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/widgets/media_tab_base.dart';
import 'package:iptv/widgets/my_list_tile.dart';
import 'package:iptv/views/player/series/page.dart';
import 'package:iptv/views/search/series.dart';
import 'package:provider/provider.dart';

class SeriesTab extends StatefulWidget {
  const SeriesTab({super.key});

  @override
  State<SeriesTab> createState() => _SeriesTabState();
}

class _SeriesTabState extends State<SeriesTab> {
  // final SelectedTabController _selectedTabController = Get.find();
  late MetaDataProvider metaDataProvider;
  List<CategoryModel> seriesCategories = [];
  List<SeriesStreamModel> seriesStreams = [];

  @override
  void initState() {
    super.initState();
    metaDataProvider = Provider.of<MetaDataProvider>(context, listen: false);
    seriesCategories = metaDataProvider.getSeriesCategories();
    seriesStreams = metaDataProvider.seriesStreams;
  }

  @override
  Widget build(BuildContext context) {
    return MediaTabBase(
      categories: seriesCategories,
      streams: seriesStreams,
      getCategoryId: (stream) => (stream as SeriesStreamModel).categoryId ?? "",
      getSelectedCategoryId: (provider) => provider.categoryTabSeriesId,
      setSelectedCategory: (provider, id) => provider.setCategoryTabSeries(id),
      searchTag: 'series',
      onSearchTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SeriesSearch(
                searchTag: 'series',
              ),
            ));
      },
      listBuilder: (context, filteredStreams) {
        return ListView.separated(
          separatorBuilder: (context, index) {
            return VerticalGap(
              height: Constants.gap,
            );
          },
          itemCount: filteredStreams.length,
          itemBuilder: (context, index) {
            final series = filteredStreams[index] as SeriesStreamModel;

            return MyListTile(
              title: series.name ?? "",
              iconUrl: series.cover,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeriesDetailsPage(
                      series: series,
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
