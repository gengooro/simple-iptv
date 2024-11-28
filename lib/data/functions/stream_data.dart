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

  static Future<VodData?> getVod(String streamId, String tmdbId) async {
    final SelectedAccountProvider selectedAccountProvider =
        Provider.of(Get.context!, listen: false);
    final Account account = selectedAccountProvider.account;

    Dio dio = Dio();

    try {
      final movieDataResponse = await dio.get(
          "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_vod_info&vod_id=$streamId");

      if (movieDataResponse.statusCode != 200) {
        return null;
      }

      final movieData =
          MovieData.fromJson(movieDataResponse.data["movie_data"]);

      final imdbDataResponse = await dio.get(
          "https://api.themoviedb.org/3/movie/$tmdbId?api_key=d7a8f9298ee33fadc48f6078581804c3");

      if (imdbDataResponse.statusCode != 200) {
        return null;
      }

      final imdbData = TmdbVod.fromJson(imdbDataResponse.data);

      return VodData(
        tmdbVod: imdbData,
        movieData: movieData,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<TmdbVideos> getTmdbVideos(String tmdbId) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
          "https://api.themoviedb.org/3/movie/$tmdbId/videos?api_key=d7a8f9298ee33fadc48f6078581804c3");
      return TmdbVideos.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
    // return "https://api.themoviedb.org/3/movie/$tmdbId/videos?api_key=d7a8f9298ee33fadc48f6078581804c3";
  }
}
