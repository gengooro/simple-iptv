import 'package:flutter/material.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/widgets/dot_separated_text.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeriesDetailsSkeleton extends StatelessWidget {
  const SeriesDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const isEnabled = true;

    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeletonizer(
            enabled: isEnabled,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset("assets/noimage1280x720.png"),
            ),
          ),
          VerticalGap(height: Constants.gap),
          Skeletonizer(
            enabled: isEnabled,
            child: Text(
              "lorem ipsum dolor sit amet dolor sit amet dolor",
              style: context.appTextTheme.titleMedium,
            ),
          ),
          VerticalGap(height: Constants.gap / 2),
          const Skeletonizer(
            enabled: isEnabled,
            child: DotSeparatedTexts(
              texts: [
                Text("some big data"),
                Text("some big data"),
                Text("some big data"),
              ],
            ),
          ),
          const Skeletonizer(
            child: Text("Genres, Gengre"),
          ),
          VerticalGap(height: Constants.gap / 2),
          Row(
            children: [
              Expanded(
                child: Skeletonizer(
                  enabled: isEnabled,
                  child: Container(
                    color: Colors.grey.shade200,
                    width: double.infinity,
                    height: 50.h,
                  ),
                ),
              ),
              HorizontalGap(width: Constants.gap),
              Expanded(
                child: Skeletonizer(
                  enabled: isEnabled,
                  child: Container(
                    color: Colors.grey.shade200,
                    width: double.infinity,
                    height: 50.h,
                  ),
                ),
              ),
            ],
          ),
          VerticalGap(height: Constants.gap / 2),
          const Skeletonizer(
            child: Divider(),
          ),
          VerticalGap(height: Constants.gap / 2),
          const Skeletonizer(
            child: Text("More Videos in this category"),
          ),
          VerticalGap(height: Constants.gap / 2),
          Expanded(
            child: Skeletonizer(
              enabled: isEnabled,
              child: ListView.separated(
                separatorBuilder: (_, __) => VerticalGap(height: 7.h),
                itemCount: 10,
                itemBuilder: (context, index) => Container(
                  color: Colors.grey.shade200,
                  width: double.infinity,
                  height: 50.h,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
