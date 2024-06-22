import 'package:flutter/material.dart';

import '../res/export_res.dart';
import '../utils/export_utils.dart';

class SearchWidget extends StatelessWidget {
  final void Function(String query) onSubmitted;
  final double? height;
  final EdgeInsetsGeometry? padding;
  const SearchWidget(
      {super.key, required this.onSubmitted, this.height, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      height: height ?? 75,
      child: Container(
        width: context.mediaSize.width,
        decoration: BoxDecoration(
            color: War9aColors.greyF5, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          textInputAction: TextInputAction.go,
          decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search'),
          onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}
