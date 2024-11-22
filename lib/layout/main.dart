import 'package:flutter/material.dart';
import 'package:iptv/layout/mobile/home.dart';
import 'package:iptv/layout/tv/home.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Function to determine if the device is a TV
Future<bool> isTV() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
  return androidInfo.systemFeatures.contains('android.software.leanback');
}

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isTV(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return const TvLayout(); // Show TV layout if it's a TV device
          } else {
            return const MobileLayout(); // Show Mobile layout otherwise
          }
        }
        // Show a loading indicator while waiting for the Future to complete
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
