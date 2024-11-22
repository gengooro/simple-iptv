import 'package:flutter/material.dart';
import 'package:iptv/database/account.dart';

class SelectedAccountProvider extends ChangeNotifier {
  Account _account = Account();
  Account get account => _account;

  void setAccount(Account account) {
    _account = account;
  }
}
