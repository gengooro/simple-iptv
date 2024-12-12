import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iptv/providers/selected_account.dart';
import 'package:iptv/data/xtream.dart/categories.dart';
import 'package:iptv/data/xtream.dart/streams.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:iptv/database/xtream/newmetadata.dart';
import 'package:iptv/database/xtream/streams/live.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/database/xtream/streams/vod.dart';
import 'package:provider/provider.dart';

class MetaDataProvider extends ChangeNotifier {
  bool _isFetching = false;
  String _fetchingMessage = "Initializing";

  late Box<CategoryModel> categoryBox;
  late Box<LiveStreamModel> liveStreamBox;
  late Box<VodStreamModel> vodStreamBox;
  late Box<SeriesStreamModel> seriesStreamBox;

  List<CategoryModel> categories = [];
  List<LiveStreamModel> liveStreams = [];
  List<VodStreamModel> vodStreams = [];
  List<SeriesStreamModel> seriesStreams = [];

  List<NewMetaData> newMetaData = [];

  bool get isFetching => _isFetching;
  String get fetchingMessage => _fetchingMessage;

  Future<void> initializeBoxes() async {
    final selectedAccountProvider =
        Provider.of<SelectedAccountProvider>(Get.context!, listen: false);
    final account = selectedAccountProvider.account;

    _fetchingMessage = "Getting things ready";
    // Open all boxes before using them
    categoryBox =
        await Hive.openBox<CategoryModel>('categories_${account.username}');
    liveStreamBox =
        await Hive.openBox<LiveStreamModel>('live_${account.username}');
    vodStreamBox =
        await Hive.openBox<VodStreamModel>('vod_${account.username}');
    seriesStreamBox =
        await Hive.openBox<SeriesStreamModel>('series_${account.username}');
  }

  Future<void> fetchAndStoreData() async {
    _isFetching = true;
    notifyListeners();

    try {
      await initializeBoxes();

      if (categoryBox.isEmpty ||
          liveStreamBox.isEmpty ||
          vodStreamBox.isEmpty ||
          seriesStreamBox.isEmpty) {
        debugPrint("Data missing in one or more boxes, fetching from API...");

        // Fetch data from API
        _fetchingMessage = "Fetching live categories";
        notifyListeners();

        final liveCategoriesData = await fetchLiveCategoriesFromAPI();
        _fetchingMessage = "Fetched live categories";
        notifyListeners();

        _fetchingMessage = "Fetching vod categories";
        notifyListeners();

        final vodCategoriesData = await fetchVodCategoriesFromAPI();
        _fetchingMessage = "Fetched vod categories";
        notifyListeners();

        _fetchingMessage = "Fetching series categories";
        notifyListeners();

        final seriesCategoriesData = await fetchSeriesCategoriesFromAPI();
        _fetchingMessage = "Fetched series categories";
        notifyListeners();

        _fetchingMessage = "Fetching live streams";
        notifyListeners();

        final liveStreamsData = await fetchLiveStreamsFromAPI();
        _fetchingMessage = "Fetched live streams";
        notifyListeners();

        _fetchingMessage = "Fetching vod streams";
        notifyListeners();

        final vodStreamsData = await fetchVodStreamsFromAPI();
        _fetchingMessage = "Fetched vod streams";
        notifyListeners();

        _fetchingMessage = "Fetching series streams";
        notifyListeners();

        final seriesStreamsData = await fetchSeriesStreamsFromAPI();
        _fetchingMessage = "Fetched series streams";
        notifyListeners();

        // Combine category data
        List<CategoryModel> allCategories = [];
        allCategories.addAll(liveCategoriesData);
        allCategories.addAll(vodCategoriesData);
        allCategories.addAll(seriesCategoriesData);

        // Add live streams, vod streams, and series streams data to their respective lists
        List<LiveStreamModel> allLiveStreams = liveStreamsData;
        List<VodStreamModel> allVodStreams = vodStreamsData;
        List<SeriesStreamModel> allSeriesStreams = seriesStreamsData;

        // Save the fetched data to Hive boxes
        if (categoryBox.isEmpty) {
          await categoryBox.addAll(allCategories);
        }

        if (liveStreamBox.isEmpty) {
          await liveStreamBox.addAll(allLiveStreams);
        }

        if (vodStreamBox.isEmpty) {
          await vodStreamBox.addAll(allVodStreams);
        }

        if (seriesStreamBox.isEmpty) {
          await seriesStreamBox.addAll(allSeriesStreams);
        }

        categories = allCategories;
        liveStreams = allLiveStreams;
        vodStreams = allVodStreams;
        seriesStreams = allSeriesStreams;
        notifyListeners();

        debugPrint("done");
      } else {
        debugPrint("All data already exists in Hive, skipping fetch");

        // Load data into state from Hive boxes
        categories = categoryBox.values.toList();
        liveStreams = liveStreamBox.values.toList();
        vodStreams = vodStreamBox.values.toList();
        seriesStreams = seriesStreamBox.values.toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching metadata: $e");
    } finally {
      _isFetching = false;
      _fetchingMessage = "";
      notifyListeners();
    }
  }

  Future<void> refetchMetadata() async {}

  List<CategoryModel> getCategoriesByType(String type) {
    return categoryBox.values
        .where((category) => category.type == type)
        .toList();
  }

  List<CategoryModel> getLiveCategories() {
    return getCategoriesByType('live');
  }

  List<CategoryModel> getVodCategories() {
    return getCategoriesByType('vod');
  }

  List<CategoryModel> getSeriesCategories() {
    return getCategoriesByType('series');
  }
}

Future<List<CategoryModel>> fetchLiveCategoriesFromAPI() async {
  final selectedAccountProvider =
      Provider.of<SelectedAccountProvider>(Get.context!, listen: false);

  final Dio dio = Dio();
  final url = Categories.liveTv(selectedAccountProvider.account);

  try {
    final res = await dio.get(url);

    if (res.data is List) {
      List<CategoryModel> categories = (res.data as List)
          .map((categoryJson) => CategoryModel.fromJson(categoryJson, 'live'))
          .toList();

      return categories;
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<CategoryModel>> fetchVodCategoriesFromAPI() async {
  final selectedAccountProvider =
      Provider.of<SelectedAccountProvider>(Get.context!, listen: false);

  final Dio dio = Dio();
  final url = Categories.vod(selectedAccountProvider.account);

  try {
    final res = await dio.get(url);

    if (res.data is List) {
      List<CategoryModel> categories = (res.data as List)
          .map((categoryJson) => CategoryModel.fromJson(categoryJson, 'vod'))
          .toList();

      return categories;
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<CategoryModel>> fetchSeriesCategoriesFromAPI() async {
  final selectedAccountProvider =
      Provider.of<SelectedAccountProvider>(Get.context!, listen: false);

  final Dio dio = Dio();
  final url = Categories.series(selectedAccountProvider.account);

  try {
    final res = await dio.get(url);

    if (res.data is List) {
      List<CategoryModel> categories = (res.data as List)
          .map((categoryJson) => CategoryModel.fromJson(categoryJson, 'series'))
          .toList();

      return categories;
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<LiveStreamModel>> fetchLiveStreamsFromAPI() async {
  final selectedAccountProvider =
      Provider.of<SelectedAccountProvider>(Get.context!, listen: false);

  final Dio dio = Dio();
  final url = Streams.liveTv(selectedAccountProvider.account);

  try {
    final res = await dio.get(url);

    if (res.data is List) {
      List<LiveStreamModel> streams = (res.data as List)
          .map((categoryJson) => LiveStreamModel.fromJson(categoryJson))
          .toList();

      debugPrint("Live Streams fetched from API");
      return streams;
    } else {
      debugPrint("response isnt list");
      return [];
    }
  } catch (e) {
    debugPrint("Error: $e");
    rethrow;
  }
}

Future<List<VodStreamModel>> fetchVodStreamsFromAPI() async {
  final selectedAccountProvider =
      Provider.of<SelectedAccountProvider>(Get.context!, listen: false);

  final Dio dio = Dio();
  final url = Streams.vod(selectedAccountProvider.account);

  try {
    final res = await dio.get(url);

    if (res.data is List) {
      List<VodStreamModel> streams = (res.data as List)
          .map((categoryJson) => VodStreamModel.fromJson(categoryJson))
          .toList();

      return streams;
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<SeriesStreamModel>> fetchSeriesStreamsFromAPI() async {
  final selectedAccountProvider =
      Provider.of<SelectedAccountProvider>(Get.context!, listen: false);

  final Dio dio = Dio();
  final url = Streams.series(selectedAccountProvider.account);

  try {
    final res = await dio.get(url);

    if (res.data is List) {
      List<SeriesStreamModel> streams = (res.data as List)
          .map((categoryJson) => SeriesStreamModel.fromJson(categoryJson))
          .toList();

      return streams;
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}
