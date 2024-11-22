import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
import 'package:iptv/controllers/accounts.dart';
import 'package:iptv/database/account.dart';
import 'package:iptv/extension/snackbar.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/models/xtream_form.dart';
import 'package:iptv/models/xtream_response.dart';
import 'package:iptv/widgets/error_dialog.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/data/date_utils.dart';
import 'package:provider/provider.dart';

class AccountFormDialog extends StatefulWidget {
  const AccountFormDialog({super.key});

  @override
  State<AccountFormDialog> createState() => _AccountFormDialogState();
}

class _AccountFormDialogState extends State<AccountFormDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _serverController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Account'),
      content: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              style: context.appTextTheme.bodyMedium,
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name', filled: true),
              textInputAction: TextInputAction.next,
            ),
            VerticalGap(height: 10.h),
            TextField(
              style: context.appTextTheme.bodyMedium,
              controller: _serverController,
              decoration:
                  const InputDecoration(hintText: 'Server', filled: true),
              textInputAction: TextInputAction.next,
            ),
            VerticalGap(height: 10.h),
            TextField(
              style: context.appTextTheme.bodyMedium,
              controller: _usernameController,
              decoration:
                  const InputDecoration(hintText: 'Username', filled: true),
              textInputAction: TextInputAction.next,
            ),
            VerticalGap(height: 10.h),
            TextField(
              style: context.appTextTheme.bodyMedium,
              controller: _passwordController,
              decoration:
                  const InputDecoration(hintText: 'Password', filled: true),
              textInputAction: TextInputAction.next,
              obscureText: true,
            ),
            VerticalGap(height: 10.h),
            ElevatedButton.icon(
              onPressed: () {
                final data = XtreamForm(
                  name: _nameController.text,
                  server: _serverController.text,
                  username: _usernameController.text,
                  password: _passwordController.text,
                );

                if (data.name!.isEmpty ||
                    data.server!.isEmpty ||
                    data.username!.isEmpty ||
                    data.password!.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const ErrorDialog(
                        title: "Error",
                        content: "All fields are required",
                      );
                    },
                  );

                  return;
                }

                if ((data.server!.startsWith("http://")) ||
                    (data.server!.startsWith("https://"))) {
                  verifyXtream(data, context);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => const ErrorDialog(
                          title: "Error",
                          content: "Server should be a valid http/https url"));
                  return;
                }
              },
              icon: const Icon(Icons.save),
              label: Text(
                "Verify and Save",
                style: context.appTextTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

Future<void> verifyXtream(XtreamForm data, BuildContext context) async {
  // final AccountController accountService = Get.find();
  final accountProvider = Provider.of<AccountProvider>(context, listen: false);
  final Dio dio = Dio();
  try {
    // Construct the URI
    var uri =
        "${data.server}/player_api.php?username=${data.username}&password=${data.password}";

    // Send the request
    var res = await dio.get(uri);

    // Check for HTTP errors
    if (res.statusCode != 200) {
      showSnackBar("Failed to verify account. Please try again.");
      return;
    }

    var response;

    if (res.data is Map<String, dynamic>) {
      response = XstreamResponse.fromJson(res.data);
    } else if (res.data is String) {
      response = XstreamResponse.fromJson(jsonDecode(res.data));
    }

    // Parse the response
    // final response = XstreamResponse.fromJson(res.data);

    // Validate user info
    if (response.userInfo == null) {
      showSnackBar("Invalid Xtream Account");
      return;
    }

    // Create Account instance
    final account = Account(
      name: data.name,
      serverUrl: response.serverInfo!.url,
      port: response.serverInfo!.port,
      serverProtocol: response.serverInfo!.serverProtocol,
      username: response.userInfo!.username,
      password: response.userInfo!.password,
      createdAt: MyDateUtils.unixTimeToDateTime(
          int.parse(response.userInfo!.createdAt!)),
      expiresAt: MyDateUtils.unixTimeToDateTime(
          int.parse(response.userInfo!.expDate!)),
    );

    // Add the account
    accountProvider.addAccount(account);

    // Show success message and close dialog/screen
    showSnackBar("Account added");
    Navigator.pop(context);
  } catch (e) {
    debugPrint("Error verifying Xtream account: $e");
    showSnackBar("Invalid Xtream Account or Network Error");
  }
}
