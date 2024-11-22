import 'package:flutter/material.dart';

class CategoryTabProvider extends ChangeNotifier {
  String _categoryTabLiveTvId = "";
  String _categoryTabVodId = "";
  String _categoryTabSeriesId = "";

  String get categoryTabLiveTvId => _categoryTabLiveTvId;
  String get categoryTabVodId => _categoryTabVodId;
  String get categoryTabSeriesId => _categoryTabSeriesId;

  void setCategoryTabLiveTv(String categoryId) {
    _categoryTabLiveTvId = categoryId;
    notifyListeners();
  }

  void setCategoryTabVod(String categoryId) {
    _categoryTabVodId = categoryId;
    notifyListeners();
  }

  void setCategoryTabSeries(String categoryId) {
    _categoryTabSeriesId = categoryId;
    notifyListeners();
  }
}
