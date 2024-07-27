import 'package:flutter/material.dart';

import '../../../res/export_res.dart';
import '../../../utils/app_context.dart';
import '../../models/item_content.dart';

class ItemDataSurat extends StatelessWidget {
  final Content data;
  const ItemDataSurat({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final Content(:title, :text, :path) = data;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: context.mediaSize.width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: War9aColors.greyE2.withOpacity(0.15),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Expanded(
                child: path != null
                    ? SvgGenImage(path).svg()
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
                    text,
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
