import 'package:flutter/material.dart';

import '../../../models/item_data_profile.dart';
import '../../../res/export_res.dart';
import '../../../utils/app_context.dart';

class ItemProfile extends StatelessWidget {
  final ItemDataProfile dataProfile;
  const ItemProfile({super.key, required this.dataProfile});

  @override
  Widget build(BuildContext context) {
    final ItemDataProfile(:title, :content, :path) = dataProfile;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: context.mediaSize.width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
            color: War9aColors.grey.withOpacity(0.15),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Expanded(
                child: path != null
                    ? AssetGenImage(path).image()
                    : const Icon(Icons.abc)),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: War9aTextstyle.blackW600Font16,
                  ),
                  Text(
                    content,
                    style: War9aTextstyle.blackW500Font13,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
