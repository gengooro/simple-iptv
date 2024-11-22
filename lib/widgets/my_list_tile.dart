import 'package:flutter/material.dart';
import 'package:iptv/data/function.dart';
import 'package:iptv/extension/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {super.key, required this.title, required this.onTap, this.iconUrl});

  final String title;
  final Function() onTap;
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    final cropTitle = Functions.cropText(title, 30);

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.r),
      ),
      tileColor: context.appColorScheme.surfaceContainer,
      selectedTileColor: context.appColorScheme.primaryContainer,
      focusColor: context.appColorScheme.primaryContainer,
      hoverColor: context.appColorScheme.primaryContainer,
      enableFeedback: true,
      contentPadding: EdgeInsets.all(8.r),
      title: Text(
        cropTitle,
        style: context.appTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: iconUrl?.isEmpty ?? true
          ? Image.asset(
              "assets/noimage.jpg",
              width: 64,
              height: 64,
              fit: BoxFit.contain,
            )
          : Image.network(
              iconUrl ?? "",
              fit: BoxFit.fill,
              width: 64,
              height: 64,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                color: Colors.red,
                size: 64,
              ),
            ),
      onTap: onTap,
    );
  }
}
