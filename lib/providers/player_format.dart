import 'package:flutter/material.dart';
import 'package:iptv/models/enums/index.dart';

class PlayerFormatProvider extends ChangeNotifier {
  String liveTv = VideoFormat.hls.name;

  void setFormat(VideoFormat format) {
    liveTv = format.name;
    notifyListeners();
  }
}
