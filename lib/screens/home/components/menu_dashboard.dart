import 'package:flutter/material.dart';

import '../../../models/item_dashboard.dart';
import '../../../utils/export_utils.dart';
import 'item_menu.dart';

class MenuDashboard extends StatelessWidget {
  final List<ItemDashboard> contents;
  const MenuDashboard({super.key, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.mediaSize.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
        ),
        itemCount: contents.length,
        itemBuilder: (context, index) =>
            ItemMenu(itemDashboard: contents[index]),
      ),
    );
  }
}
