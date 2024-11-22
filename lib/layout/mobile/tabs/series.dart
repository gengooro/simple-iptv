import 'package:flutter/material.dart';
import 'package:iptv/controllers/metadata.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/widgets/media_tab_base.dart';
import 'package:iptv/widgets/search/series.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      metaDataProvider =
          Provider.of<MetaDataProvider>(this.context, listen: false);
      seriesCategories = metaDataProvider.getSeriesCategories();
      seriesStreams = metaDataProvider.seriesStreams;
    });
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
              builder: (context) => const SeriesSearch(),
            ));
      },
      listBuilder: (context, filteredStreams) {
        return ListView.builder(
          itemCount: filteredStreams.length,
          itemBuilder: (context, index) {
            final series = filteredStreams[index] as SeriesStreamModel;
            return Text(series.name ?? "");
          },
        );
      },
    );
  }
}
