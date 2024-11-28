import 'package:flutter/material.dart';
import 'package:iptv/extension/theme.dart';

class DotSeparatedTexts extends StatelessWidget {
  final List<Widget> texts;
  final double spacing;

  const DotSeparatedTexts({
    super.key,
    required this.texts,
    this.spacing = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out invalid or empty widgets like SizedBox
    final validTexts = texts.where((text) => text is! SizedBox).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < validTexts.length; i++) ...[
          validTexts[i],
          if (i < validTexts.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: Text("·", style: context.appTextTheme.labelMedium),
            ),
        ],
      ],
    );
  }
}
