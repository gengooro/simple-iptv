import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iptv/data/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TvLayout extends StatefulWidget {
  const TvLayout({super.key});

  @override
  State<TvLayout> createState() => _TvLayoutState();
}

class _TvLayoutState extends State<TvLayout> {
  final FocusNode _addIptvButtonFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _addIptvButtonFocusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          Constants.appName,
          style:
              GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600),
        )),
        body: Center(
          child: Text("Hey"),
        ));
  }
}
