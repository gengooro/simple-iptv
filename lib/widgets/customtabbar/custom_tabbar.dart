import 'package:flutter/material.dart';
import 'package:iptv/providers/tab.dart';
import 'package:iptv/widgets/customtabbar/tab.dart';
import 'package:provider/provider.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs; // A list of tab labels.
  final List<Widget> views; // A list of views corresponding to each tab.

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: 60, // Adjust the height to your needs
            child: ListView.builder(
              itemCount: tabs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CustomTab(
                  onTap: () {
                    // Change the selected index using the provider
                    context.read<TabState>().setSelectedIndex(index);
                  },
                  tabs: tabs,
                  index: index,
                  isSelected: context.watch<TabState>().selectedIndex == index,
                );
              },
            ),
          ),
        ),
        // Tab view
        Expanded(
          child: Consumer<TabState>(
            builder: (context, tabState, child) {
              return views[
                  tabState.selectedIndex]; // Show the selected tab's view
            },
          ),
        ),
      ],
    );
  }
}
