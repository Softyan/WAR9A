import 'package:flutter/material.dart';

import '../../../components/export_components.dart';
import '../../../models/user.dart';
import '../../../res/export_res.dart';
import '../../../utils/app_context.dart';

class ItemDataWarga extends StatelessWidget {
  final User user;
  final int index;
  const ItemDataWarga({super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final User(:name) = user;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: context.mediaSize.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: index.isEven
                ? War9aColors.primaryColor.withOpacity(0.22)
                : War9aColors.greyE2.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(name)],
                )),
            Expanded(
                child: Button(
              'Detail',
              onPressed: () {},
              height: 30,
            ))
          ],
        ),
      ),
    );
  }
}
