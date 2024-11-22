import 'package:flutter/material.dart';

class VerticalGap extends StatelessWidget {
  final double? height;
  const VerticalGap({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class HorizontalGap extends StatelessWidget {
  final double? width;
  const HorizontalGap({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
