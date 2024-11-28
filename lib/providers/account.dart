// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:iptv/controllers/selected_account.dart';
// import 'package:iptv/data/xtream.dart/categories.dart';
// import 'package:iptv/database/xtream/category.dart';
// import 'package:iptv/database/xtream/streams/live.dart';
// import 'package:iptv/database/xtream/streams/series.dart';
// import 'package:iptv/database/xtream/streams/vod.dart';

// class AccountController extends GetxController {
//   static AccountController get instance => Get.find<AccountController>();

//   // Observable variables to track loading state and errors
//   final isLoading = false.obs;
//   final error = RxString('');

//   // Store current account name
//   final currentAccount = RxString('');

//   Future<void> fetchAndStoreData(String accountName) async {
//     debugPrint('Fetching data for $accountName');
//     try {
//       isLoading.value = true;
//       error.value = '';
//       currentAccount.value = accountName;

//       // Open a single box for categories
//       final categoryBox =
//           await Hive.openBox<CategoryModel>('categories_$accountName');

//       // Open separate boxes for streams
//       final liveStreamBox =
//           await Hive.openBox<LiveStreamModel>('live_streams_$accountName');
//       final vodStreamBox =
//           await Hive.openBox<VodStreamModel>('vod_streams_$accountName');
//       final seriesStreamBox =
//           await Hive.openBox<SeriesStreamModel>('series_streams_$accountName');

//       // Check if data already exists
//       if (categoryBox.isEmpty) {
//         // Fetch data (replace with your API call)
//         final liveCategories = await fetchLiveCategoriesFromAPI();
//         // debugPrint("livecategories: ${liveCategories.toString()}");
//         final vodCategories = await fetchVodCategoriesFromAPI();
//         final seriesCategories = await fetchSeriesCategoriesFromAPI();

//         final liveStreams = await fetchLiveStreamsFromAPI();
//         final vodStreams = await fetchVodStreamsFromAPI();
//         final seriesStreams = await fetchSeriesStreamsFromAPI();

//         // Store categories in one box
//         await categoryBox.addAll([
//           ...liveCategories.map(
//               (e) => CategoryModel.fromJson(e as Map<String, dynamic>, 'live')),
//           ...vodCategories.map(
//               (e) => CategoryModel.fromJson(e as Map<String, dynamic>, 'vod')),
//           ...seriesCategories.map((e) =>
//               CategoryModel.fromJson(e as Map<String, dynamic>, 'series')),
//         ]);
//         update();

//         debugPrint(
//             "Parsed category: ${liveCategories.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>, 'live'))}");

//         // Store streams in respective boxes
//         await liveStreamBox.addAll(liveStreams
//             .map((e) => LiveStreamModel.fromJson(e as Map<String, dynamic>))
//             .toList());
//         await vodStreamBox.addAll(vodStreams
//             .map((e) => VodStreamModel.fromJson(e as Map<String, dynamic>))
//             .toList());
//         await seriesStreamBox.addAll(seriesStreams
//             .map((e) => SeriesStreamModel.fromJson(e as Map<String, dynamic>))
//             .toList());

//         debugPrint("livecategories: ${liveCategories.toString()}");
//       }
//     } catch (e) {
//       error.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   List<CategoryModel> getCategoriesByType(String accountName, String type) {
//     try {
//       final categoryBox = Hive.box<CategoryModel>('categories_$accountName');
//       return categoryBox.values
//           .where((category) => category.type == type)
//           .toList();
//     } catch (e) {
//       error.value = e.toString();
//       return [];
//     }
//   }

//   List<LiveStreamModel> getLiveStreams(String accountName) {
//     try {
//       final liveStreamBox =
//           Hive.box<LiveStreamModel>('live_streams_$accountName');
//       return liveStreamBox.values.toList();
//     } catch (e) {
//       error.value = e.toString();
//       return [];
//     }
//   }

//   List<VodStreamModel> getVodStreams(String accountName) {
//     try {
//       final vodStreamBox = Hive.box<VodStreamModel>('vod_streams_$accountName');
//       return vodStreamBox.values.toList();
//     } catch (e) {
//       error.value = e.toString();
//       return [];
//     }
//   }

//   List<SeriesStreamModel> getSeriesStreams(String accountName) {
//     try {
//       final seriesStreamBox =
//           Hive.box<SeriesStreamModel>('series_streams_$accountName');
//       return seriesStreamBox.values.toList();
//     } catch (e) {
//       error.value = e.toString();
//       return [];
//     }
//   }

//   // Clear data for an account
//   Future<void> clearAccountData(String accountName) async {
//     try {
//       await Hive.deleteBoxFromDisk('categories_$accountName');
//       await Hive.deleteBoxFromDisk('live_streams_$accountName');
//       await Hive.deleteBoxFromDisk('vod_streams_$accountName');
//       await Hive.deleteBoxFromDisk('series_streams_$accountName');
//     } catch (e) {
//       error.value = e.toString();
//     }
//   }

//   // Dispose method to close boxes when controller is disposed
//   @override
//   void onClose() {
//     if (currentAccount.value.isNotEmpty) {
//       Hive.box<CategoryModel>('categories_${currentAccount.value}').close();
//       Hive.box<LiveStreamModel>('live_streams_${currentAccount.value}').close();
//       Hive.box<VodStreamModel>('vod_streams_${currentAccount.value}').close();
//       Hive.box<SeriesStreamModel>('series_streams_${currentAccount.value}')
//           .close();
//     }
//     super.onClose();
//   }
// }

// Future<List<CategoryModel>> fetchLiveCategoriesFromAPI() async {
//   SelectedAccountController selectedAccountController = Get.find();
//   final Dio dio = Dio();
//   final url = Categories.liveTv(selectedAccountController.account.value);

//   try {
//     final res = await dio.get(url);

//     if (res.data is List) {
//       List<CategoryModel> categories = (res.data as List)
//           .map((categoryJson) => CategoryModel.fromJson(categoryJson, 'live'))
//           .toList();

//       return categories;
//     } else {
//       return []; // Return empty list if the data is not a List
//     }
//   } catch (e) {
//     debugPrint("Error fetching categories: $e");
//     return []; // Return empty list on error
//   }
// }

// Future<List<CategoryModel>> fetchVodCategoriesFromAPI() async {
//   // Replace with your API call
//   return [];
// }

// Future<List<CategoryModel>> fetchSeriesCategoriesFromAPI() async {
//   // Replace with your API call
//   return [];
// }

// Future<List<LiveStreamModel>> fetchLiveStreamsFromAPI() async {
//   // Replace with your API call
//   return [];
// }

// Future<List<VodStreamModel>> fetchVodStreamsFromAPI() async {
//   // Replace with your API call
//   return [];
// }

// Future<List<SeriesStreamModel>> fetchSeriesStreamsFromAPI() async {
//   //Replace with your API call
//   return [];
// }
