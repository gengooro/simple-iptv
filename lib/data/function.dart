import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:iptv/models/enums/index.dart';
import 'package:iptv/providers/player_format.dart';
import 'package:iptv/providers/selected_account.dart';
import 'package:iptv/database/account.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Functions {
  static String cropText(String text, int length) {
    return text.length > length ? "${text.substring(0, length)}..." : text;
  }

  static getNewMetaData(Account account) {
    // http://cf.gocdn8k.me/get.php?username=iptvflag2q7&password=nzkb8vat7f&type=m3u_plus&output=ts
    return "${account.serverProtocol}://${account.serverUrl}/get.php?username=${account.username}&password=${account.password}&type=m3u_plus&output=ts";
  }

  static String getHLSUrlwithExtension(BuildContext context, dynamic streamId) {
    final account = context.read<SelectedAccountProvider>().account;
    final format = getExtension();

    return "${account.serverProtocol}://${account.serverUrl}/live/${account.username}/${account.password}/$streamId.$format";
  }

  static String getExtension() {
    final liveTvString = PlayerFormatProvider().liveTv;

    // Convert the string back to the enum
    VideoFormat? format;
    try {
      format = VideoFormat.values.firstWhere((e) => e.name == liveTvString);
    } catch (e) {
      format = null; // Handle invalid input gracefully.
    }

    switch (format) {
      case VideoFormat.hls:
        return "m3u8";
      case VideoFormat.other:
        return "ts";
      default:
        return "m3u8"; // Default value.
    }
  }

  static BetterPlayerVideoFormat getBetterPlayerFormat() {
    final format = getExtension();

    switch (format) {
      case "m3u8":
        return BetterPlayerVideoFormat.hls;
      case "ts":
        return BetterPlayerVideoFormat.other;
      default:
        return BetterPlayerVideoFormat.hls; // Default value.
    }
  }

  static String getSeriesEpisodeUrl(
      BuildContext context, dynamic streamId, String extension) {
    final SelectedAccountProvider selectedAccountProvider =
        Provider.of(context, listen: false);
    final Account account = selectedAccountProvider.account;

    final url =
        "${account.serverProtocol}://${account.serverUrl}/series/${account.username}/${account.password}/$streamId.$extension";

    return url;
  }

  static String getVodUrl(
      BuildContext context, dynamic streamId, String extension) {
    final SelectedAccountProvider selectedAccountProvider =
        Provider.of(context, listen: false);
    final Account account = selectedAccountProvider.account;

    final url =
        "${account.serverProtocol}://${account.serverUrl}:${account.port}/movie/${account.username}/${account.password}/$streamId.$extension";

    return url;
  }

  static String getImdbImageUrl(String imageUrl) {
    // https://image.tmdb.org/t/p/w1280_and_h720_bestv2/jGm7gRkDX4ZdxCk8vWneTPSUzNl.jpg
    return "https://image.tmdb.org/t/p/w1280_and_h720_bestv2$imageUrl";
  }

  static void openUrl(String url, String title) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, webOnlyWindowName: title);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchYoutubeUrl(String youtubeId) async {
    final url = "https://youtu.be/$youtubeId";

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, webOnlyWindowName: "Youtube");
    } else {
      throw 'Could not launch $url';
    }
  }
}
