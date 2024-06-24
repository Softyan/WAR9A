import 'package:flutter/material.dart';

import '../models/surat.dart';
import '../res/export_res.dart';
import '../utils/export_utils.dart';

class ItemSurat extends StatelessWidget {
  final Surat surat;
  final int index;
  final bool fromDataSurat;
  final void Function()? onClick;
  const ItemSurat(
      {super.key,
      required this.surat,
      required this.index,
      this.onClick,
      this.fromDataSurat = true});

  @override
  Widget build(BuildContext context) {
    final Surat(:from, :noSurat, :createdAt, :keperluan) = surat;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fromDataSurat ? "Asal Surat" : "Pemohon",
              style: War9aTextstyle.normal.copyWith(fontSize: 8),
            ),
            Text(
              from.ifEmpty(),
              style: War9aTextstyle.blackW600Font16.copyWith(fontSize: 20),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              fromDataSurat ? "Nomor Surat" : "Keperluan",
              style: War9aTextstyle.normal.copyWith(fontSize: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    fromDataSurat ? noSurat : keperluan,
                    style: War9aTextstyle.normal.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    createdAt?.formatDefault ?? '-',
                    style: War9aTextstyle.blackW400Font10,
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
