import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/providers/bottom_navigation.dart';
import 'package:iptv/providers/metadata.dart';
import 'package:iptv/providers/selected_account.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/layout/mobile/tabs/live_tv.dart';
import 'package:iptv/layout/mobile/tabs/search.dart';
import 'package:iptv/layout/mobile/tabs/series.dart';
import 'package:iptv/layout/mobile/tabs/settings.dart';
import 'package:iptv/layout/mobile/tabs/vod.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late MetaDataProvider metaDataProvider;
  bool _initializing = true;

  final List<Widget> _tabs = [
    const LiveTvTab(),
    const VodTab(),
    const SearchTab(),
    const SeriesTab(),
    const SettingsTab()
  ];

  @override
  void initState() {
    super.initState();
    metaDataProvider = Provider.of<MetaDataProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() => _initializing = true);
        await metaDataProvider.initializeBoxes();
        await metaDataProvider.fetchAndStoreData();
      } catch (e) {
        debugPrint('Error initializing: $e');
      } finally {
        setState(() => _initializing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
        builder: (context, bottomNavigationProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Consumer<SelectedAccountProvider>(
            builder: (context, selectedAccountProvider, child) => Text(
              selectedAccountProvider.account.name ?? "No Name",
              style: context.appTextTheme.headlineSmall,
            ),
          ),
          backgroundColor: context.appColorScheme.primaryContainer,
        ),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: bottomNavigationProvider.tabIndex,
          onDestinationSelected: (value) {
            bottomNavigationProvider.changeTabIndex(value);
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.tv),
              icon: Icon(Icons.tv_outlined),
              label: 'Live TV',
              tooltip: 'Live TV',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.movie),
              icon: Icon(Icons.movie_outlined),
              label: 'VOD',
              tooltip: 'VOD',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.search),
              icon: Icon(Icons.search_outlined),
              label: 'Search',
              tooltip: 'Search',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.local_movies),
              icon: Icon(Icons.local_movies_outlined),
              label: 'Series',
              tooltip: 'Series',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
              tooltip: 'Settings',
            ),
          ],
        ),
        body: _initializing
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    VerticalGap(height: Constants.gap / 2),
                    Text(metaDataProvider.fetchingMessage),
                  ],
                ),
              )
            : Consumer<MetaDataProvider>(
                builder: (context, metaDataProvider, child) {
                  if (metaDataProvider.isFetching) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          Text(metaDataProvider.fetchingMessage),
                        ],
                      ),
                    );
                  }

                  if (metaDataProvider.categories.isEmpty &&
                      metaDataProvider.liveStreams.isEmpty &&
                      metaDataProvider.vodStreams.isEmpty &&
                      metaDataProvider.seriesStreams.isEmpty) {
                    return const Center(child: Text("No data available"));
                  }

                  return IndexedStack(
                    index: bottomNavigationProvider.tabIndex,
                    children: _tabs,
                  );
                },
              ),
      );
    });
  }
}
