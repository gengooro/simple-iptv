import 'package:iptv/database/account.dart';

class Streams {
  static liveTv(Account account) {
    return "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_live_streams";
  }

  static vod(Account account) {
    return "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_vod_streams";
  }

  static series(Account account) {
    return "${account.serverProtocol}://${account.serverUrl}/player_api.php?username=${account.username}&password=${account.password}&action=get_series";
  }
}
