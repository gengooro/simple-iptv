import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iptv/controllers/selected_account.dart';
import 'package:iptv/data/date_utils.dart';
import 'package:iptv/controllers/accounts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/dialogs/account_delete_dialog.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/layout/mobile/dashboard.dart';
import 'package:provider/provider.dart';

class AccountList extends StatefulWidget {
  const AccountList({super.key});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  late final AccountProvider _accountProvider;

  @override
  void initState() {
    super.initState();
    _accountProvider = Provider.of<AccountProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _accountProvider
          .getAccounts(); // Fetch accounts when widget is initialized
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        final accounts = accountProvider.accounts;

        if (accountProvider.isFetching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (accounts.isEmpty) {
          return Center(
            child: Text(
              "No accounts available",
              style: context.appTextTheme.displaySmall,
            ),
          );
        }

        return ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            final account = accounts[index];
            final key = account.key;

            return Padding(
              padding: EdgeInsets.all(4.r),
              child: Consumer<SelectedAccountProvider>(
                builder: (context, selectedAccountProvider, child) => ListTile(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AccountDeleteDialog(accountKey: key),
                      );
                    },
                    onTap: () {
                      selectedAccountProvider.setAccount(account);
                      Get.to(() => const Dashboard());
                    },
                    tileColor: context.appColorScheme.surfaceContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: Container(
                      width: 24.w,
                      height: 24.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.appColorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        account.name?.substring(0, 1).toUpperCase() ?? '?',
                        style: context.appTextTheme.labelLarge?.copyWith(
                            color: context.appColorScheme.onSecondary),
                      ),
                    ),
                    title: Text(
                      account.name ?? "No Name",
                      style: context.appTextTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      account.serverUrl ?? "No Server URL",
                      style: context.appTextTheme.bodySmall,
                    ),
                    trailing: Text(
                      account.expiresAt != null
                          ? "Expires in ${MyDateUtils.getDaysLeft(account.expiresAt!)} days"
                          : "Expiration unknown",
                      style: context.appTextTheme.labelMedium,
                    )),
              ),
            );
          },
        );
      },
    );
  }
}
