import 'package:flutter/material.dart';
import 'package:iptv/widgets/search.dart';

class SeriesSearch extends StatefulWidget {
  final String? searchTag;
  const SeriesSearch({super.key, this.searchTag});

  @override
  State<SeriesSearch> createState() => _SeriesSearchState();
}

class _SeriesSearchState extends State<SeriesSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live TV'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Hero(tag: '$widget.searchTag', child: const SearchTextfield()),
        ],
      ),
    );
  }
}
