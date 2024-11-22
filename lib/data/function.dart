import 'package:flutter/material.dart';
import 'package:iptv/controllers/selected_account.dart';
import 'package:iptv/database/account.dart';
import 'package:provider/provider.dart';

class Functions {
  static String cropText(String text, int length) {
    return text.length > length ? "${text.substring(0, length)}..." : text;
  }

  static String getHLSUrl(BuildContext context, int? streamId) {
    final SelectedAccountProvider selectedAccountProvider =
        Provider.of(context, listen: false);
    final Account account = selectedAccountProvider.account;

    return "${account.serverProtocol}://${account.serverUrl}/live/${account.username}/${account.password}/$streamId.ts";
  }
}
