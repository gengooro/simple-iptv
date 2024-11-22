import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iptv/controllers/accounts.dart';
import 'package:iptv/controllers/bottom_navigation.dart';
import 'package:iptv/controllers/selected_account.dart';
import 'package:iptv/controllers/category_tab.dart';
import 'package:iptv/data/theme.dart';
import 'package:iptv/database/account.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:iptv/controllers/metadata.dart';
import 'package:iptv/database/xtream/streams/live.dart';
import 'package:iptv/database/xtream/streams/series.dart';
import 'package:iptv/database/xtream/streams/vod.dart';
import 'package:iptv/extension/snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/layout/main.dart';
import 'package:iptv/provider/recent_searches.dart';
import 'package:iptv/provider/search_items.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(LiveStreamModelAdapter());
  Hive.registerAdapter(VodStreamModelAdapter());
  Hive.registerAdapter(SeriesStreamModelAdapter());

  // Run the app
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AccountProvider()),
    ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
    ChangeNotifierProvider(create: (context) => SelectedAccountProvider()),
    ChangeNotifierProvider(create: (context) => MetaDataProvider()),
    ChangeNotifierProvider(create: (context) => CategoryTabProvider()),
    ChangeNotifierProvider(create: (context) => SearchItemsProvider()),
    ChangeNotifierProvider(
        create: (context) => RecentWatchedChannelsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) => GetMaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!);
        },
        scaffoldMessengerKey: snackbarKey,
        debugShowCheckedModeBanner: false,
        darkTheme: MyThemes.darkTheme,
        theme: MyThemes.lightTheme,
        home: const Layout(),
      ),
    );
  }
}
