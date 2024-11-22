// mobile_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iptv/data/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/dialogs/choose_account_dialog.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/widgets/account_list.dart';
import 'package:iptv/widgets/gap.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/logo.svg",
          width: 30.w,
          height: 30.h,
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => const AccountChooseDialog());
          },
          icon: const Icon(Icons.add),
          label: Text(
            "Add Account",
            style: context.appTextTheme.labelMedium,
          )),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Accounts",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            VerticalGap(height: 7.h),
            const Expanded(child: AccountList()),
          ],
        ),
      ),
    );
  }
}
