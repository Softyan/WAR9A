import 'package:flutter/material.dart';

import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';

class SearchWarga extends StatelessWidget {
  final Function(String) onSubmitted;
  const SearchWarga({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Container(
        width: context.mediaSize.width,
        height: 50,
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
