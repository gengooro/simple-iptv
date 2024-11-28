import 'package:flutter/material.dart';
import 'package:iptv/extension/theme.dart';

class SearchTextfield extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool? readOnly;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool? autofocus;

  const SearchTextfield({
    super.key,
    this.focusNode,
    this.controller,
    this.readOnly,
    this.onChanged,
    this.onTap,
    this.autofocus,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        onTap: onTap,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: context.appColorScheme.surfaceContainer,
          labelText: 'Search',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: GestureDetector(
            onTap: () {
              controller?.value = TextEditingValue.empty;
              onChanged?.call("");
            },
            child: controller?.value == TextEditingValue.empty
                ? const SizedBox()
                : const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}
