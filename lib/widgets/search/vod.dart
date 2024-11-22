import 'package:flutter/material.dart';
import 'package:iptv/widgets/search.dart';

class VodSearch extends StatefulWidget {
  final String? searchTag;
  const VodSearch({super.key, this.searchTag});

  @override
  State<VodSearch> createState() => _VodSearchState();
}

class _VodSearchState extends State<VodSearch> {
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
