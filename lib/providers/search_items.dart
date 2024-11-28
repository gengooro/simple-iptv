import 'package:flutter/material.dart';
import 'package:iptv/database/xtream/streams/live.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/database/xtream/streams/vod.dart';

class SearchItemsProvider extends ChangeNotifier {
  List<LiveStreamModel> _liveTvSearchItems = [];
  List<VodStreamModel> _vodSearchItems = [];
  List<SeriesStreamModel> _seriesSearchItems = [];

  List<LiveStreamModel> get liveTvItems => _liveTvSearchItems;
  List<VodStreamModel> get vodItems => _vodSearchItems;
  List<SeriesStreamModel> get seriesItems => _seriesSearchItems;

  set liveTvItems(List<LiveStreamModel> value) {
    _liveTvSearchItems = value;
    notifyListeners();
  }

  set vodItems(List<VodStreamModel> value) {
    _vodSearchItems = value;
    notifyListeners();
  }

  set seriesItems(List<SeriesStreamModel> value) {
    _seriesSearchItems = value;
    notifyListeners();
  }
}
