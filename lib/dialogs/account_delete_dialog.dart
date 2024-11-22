import 'package:flutter/material.dart';
import 'package:iptv/controllers/accounts.dart';
import 'package:provider/provider.dart';

class AccountDeleteDialog extends StatelessWidget {
  final dynamic accountKey;
  const AccountDeleteDialog({super.key, required this.accountKey});

  @override
  Widget build(BuildContext context) {
    // final AccountController accountService = Get.find();

    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) => FutureBuilder(
        future: accountProvider.getAccount(accountKey),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final account = snapshot.data;

          if (account == null) {
            return const Center(child: Text('Account not found'));
          }

          // Use GetX/Obx only for observing changes in the accountService or any reactive variables
          return AlertDialog.adaptive(
            title: const Text('Delete Account'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account Name: ${account.name ?? "Unknown"}'),
                const Text('Are you sure you want to delete this account?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  accountProvider.removeAccount(accountKey);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      ),
    );
  }
}
