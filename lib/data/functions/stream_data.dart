import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv/database/account.dart';
import 'package:iptv/models/streams/series.dart';
import 'package:iptv/models/streams/vod.dart';
import 'package:iptv/models/tmdb_videos.dart';
import 'package:iptv/models/tmdb_vod.dart';
import 'package:iptv/providers/selected_account.dart';
import 'package:provider/provider.dart';

class StreamData {
  static Future<SeriesData?> getSeries(String id) async {
    final SelectedAccountProvider selectedAccountProvider =
        Provider.of(Get.context!, listen: false);
    final Account account = selectedAccountProvider.account;

    Dio dio = Dio();

    try {
      final response = await dio.get(
          "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_series_info&series_id=$id");

      if (response.statusCode != 200) {
        return null;
      }

      final data = SeriesData.fromJson(response.data);
      return data;
    } catch (e) {
      return null;
    }
  }

  static Future<VodDataModel?> getVod(String streamId, String tmdbId) async {
    debugPrint("Getting vod data for $streamId");
    final SelectedAccountProvider selectedAccountProvider =
        Provider.of(Get.context!, listen: false);
    final Account account = selectedAccountProvider.account;

    Dio dio = Dio();

    try {
      final vodDataUrl =
          "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_vod_info&vod_id=$streamId";

      final vodDataResponse = await dio.get(
        vodDataUrl,
      );

      if (vodDataResponse.statusCode != 200) {
        return null;
      }

      debugPrint("Vod Data Response is ${vodDataResponse.toString()}");

      final vodData = VodDataServer.fromJson(vodDataResponse.data);

      debugPrint("Vod Data is ${vodData.toString()}");

      // if (vodData.info is Map) {
      //   debugPrint("Info is a map");
      //   if ((vodData.info as List).isNotEmpty) {
      //     return VodDataModel(vodDataServer: vodData);
      //   }
      // }

      if (tmdbId.isEmpty) {
        return VodDataModel(vodDataServer: vodData);
      }

      final tmdbDataUrl = "https://tmdb-wrapper.vercel.app/movie/$tmdbId";

      final tmdbDataResponse = await dio.get(
        tmdbDataUrl,
      );

      if (tmdbDataResponse.statusCode != 200) {
        return null;
      }

      final tmdbData = TmdbVod.fromJson(tmdbDataResponse.data);

      return VodDataModel(tmdbVod: tmdbData, vodDataServer: vodData);
    } catch (e) {
      return null;
    }
  }

  static Future<TmdbVideos> getTmdbVideos(String tmdbId) async {
    final Dio dio = Dio();
    try {
      final response =
          await dio.get("https://tmdb-wrapper.vercel.app/movie/$tmdbId/videos");
      return TmdbVideos.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
