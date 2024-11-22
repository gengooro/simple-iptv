import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/database/account.dart';

class AccountProvider extends ChangeNotifier {
  List<Account> _accounts = [];
  bool _isFetching = false;
  late Box<Account> accountBox;

  List<Account> get accounts => _accounts;
  bool get isFetching => _isFetching;

  AccountProvider() {
    _init();
  }

  Future<void> _init() async {
    await preloadBox();
    await getAccounts();
  }

  Future<void> preloadBox() async {
    try {
      accountBox = await Hive.openBox<Account>(Constants.boxAccountName);
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Failed to open Hive box: $e')),
      );
    }
  }

  void addAccount(Account account) {
    accountBox.add(account);
    _accounts = accountBox.values.toList();
    notifyListeners();
  }

  void removeAccount(dynamic accountKey) {
    accountBox.delete(accountKey);
    _accounts = accountBox.values.toList();
    notifyListeners();
  }

  Future<Account?> getAccount(dynamic accountKey) async {
    return accountBox.get(accountKey);
  }

  Future<void> getAccounts() async {
    _isFetching = true;
    notifyListeners();
    try {
      _accounts.clear();
      if (accountBox.isOpen) {
        _accounts = accountBox.values.toList();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Hive box is not open.')),
        );
      }
    } catch (e) {
      debugPrint("Error fetching accounts: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
