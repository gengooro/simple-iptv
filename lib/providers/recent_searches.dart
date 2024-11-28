import 'package:flutter/material.dart';
import 'package:iptv/database/xtream/streams/live.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/database/xtream/streams/vod.dart';

class RecentWatchedProvider with ChangeNotifier {
  List<LiveStreamModel> _liveTv = [];
  List<VodStreamModel> _vod = [];
  List<SeriesStreamModel> _series = [];

  List<LiveStreamModel> get liveTv => _liveTv;
  List<VodStreamModel> get vod => _vod;
  List<SeriesStreamModel> get series => _series;

  void addLiveTv(LiveStreamModel channel) {
    if (_liveTv.contains(channel)) {
      _liveTv.remove(channel);
      _liveTv.add(channel);
      notifyListeners();
    } else {
      _liveTv.add(channel);
      notifyListeners();
    }
  }

  void clearLiveTv() {
    _liveTv = [];
    notifyListeners();
  }

  void addVod(VodStreamModel vod) {
    if (_vod.contains(vod)) {
      _vod.remove(vod);
      _vod.add(vod);
      notifyListeners();
    } else {
      _vod.add(vod);
      notifyListeners();
    }
  }

  void clearVod() {
    _vod = [];
    notifyListeners();
  }

  void addSeries(SeriesStreamModel series) {
    if (_series.contains(series)) {
      _series.remove(series);
      _series.add(series);
      notifyListeners();
    } else {
      _series.add(series);
      notifyListeners();
    }
  }

  void clearSeries() {
    _series = [];
    notifyListeners();
  }
}
