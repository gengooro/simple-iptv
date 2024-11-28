import 'package:flutter/material.dart';

class TabState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners(); // Notify listeners to rebuild when the index changes
    }
  }
}
