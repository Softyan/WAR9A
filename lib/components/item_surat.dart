import 'package:flutter/material.dart';

import '../models/surat.dart';
import '../res/export_res.dart';
import '../utils/export_utils.dart';
import 'export_components.dart';

class ItemSurat extends StatelessWidget {
  final Surat surat;
  final int index;
  final String text1;
  final String text2;
  final void Function()? onClick;
  const ItemSurat(
      {super.key,
      required this.surat,
      required this.index,
      this.text1 = "Text 1",
      this.text2 = "Text 2",
      this.onClick});

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    Text(
                      text1,
                      style: War9aTextstyle.blackW500Font13,
                    ),
                    Text(
                      text2,
                      style: War9aTextstyle.blackW500Font13,
                    ),
                    const SpacerWidget(4),
                    Text(
                      surat.createdAt?.formatDefault ?? '-',
                      style: War9aTextstyle.blackW400Font10,
                    )
                  ],
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Button(
                'Detail',
                onPressed: onClick,
                height: 30,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
