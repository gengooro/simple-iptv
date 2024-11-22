import 'package:iptv/database/account.dart';

class Categories {
  static liveTv(Account account) {
    return "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_live_categories";
  }

  static vod(Account account) {
    return "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_vod_categories";
  }

  static series(Account account) {
    return "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_series_categories";
  }
}
