import 'package:flutter/material.dart';

import '../models/surat.dart';
import '../res/export_res.dart';
import '../utils/datetime_ext.dart';
import '../utils/export_utils.dart';
import 'export_components.dart';

class ItemSurat extends StatelessWidget {
  final Surat surat;
  final int index;
  const ItemSurat({super.key, required this.surat, required this.index});

  @override
  Widget build(BuildContext context) {
    final Surat(:from, :createdAt, :category) = surat;
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
                    Text('Pemohon : $from'),
                    Text('Keperluan : $category'),
                    Text(createdAt?.formatDefault ?? '-')
                  ],
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
