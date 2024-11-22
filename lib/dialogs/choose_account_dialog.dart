import 'package:flutter/material.dart';
import 'package:iptv/dialogs/account_form_dialog.dart';

class AccountChooseDialog extends StatefulWidget {
  const AccountChooseDialog({super.key});

  @override
  State<AccountChooseDialog> createState() => _AccountChooseDialogState();
}

class _AccountChooseDialogState extends State<AccountChooseDialog>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Account'),
      content: SizedBox(
        width: double.minPositive,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Add this
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              autofocus: true,
              onPressed: () async {
                Navigator.pop(context);
                await showDialog(
                    context: context,
                    builder: (context) => const AccountFormDialog());
              },
              icon: const Icon(Icons.code_off),
              label: const Text("XStream"),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.link),
              label: const Text("M3U Url"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.cancel),
          label: const Text('Cancel'),
        )
      ],
    );
  }
}
