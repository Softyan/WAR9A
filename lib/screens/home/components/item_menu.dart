import 'package:flutter/material.dart';

import '../../../models/item_dashboard.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';

class ItemMenu extends StatelessWidget {
  final ItemDashboard itemDashboard;
  const ItemMenu({super.key, required this.itemDashboard});

  @override
  Widget build(BuildContext context) {
    final ItemDashboard(:title, :path, :destination) = itemDashboard;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: War9aColors.grey2,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () {
          if (destination == null) return;
          AppRoute.to(destination);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: War9aColors.primaryColor,
              ),
              child: path != null ? SvgGenImage(path).svg() : Container(),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: War9aTextstyle.primaryW600Font10,
            )
          ],
        ),
      ),
    );
  }
}
