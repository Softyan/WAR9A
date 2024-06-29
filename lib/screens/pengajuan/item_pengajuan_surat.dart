import 'package:flutter/material.dart';

import '../../models/pengajuan_surat.dart';
import '../../models/step_surat.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';

class ItemPengajuanSurat extends StatelessWidget {
  final PengajuanSurat pengajuanSurat;
  final int index;
  final void Function()? onClick;
  const ItemPengajuanSurat(
      {super.key,
      required this.pengajuanSurat,
      required this.index,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    final PengajuanSurat(:name, :steps, :keperluan) = pengajuanSurat;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onClick,
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
                      "Pemohon",
                      style: War9aTextstyle.normal.copyWith(fontSize: 8),
                    ),
                    Text(
                      name.ifEmpty(),
                      style:
                          War9aTextstyle.blackW600Font16.copyWith(fontSize: 20),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Keperluan",
                      style: War9aTextstyle.normal.copyWith(fontSize: 8),
                    ),
                    Text(
                      keperluan,
                      style: War9aTextstyle.normal.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Status",
                    style: War9aTextstyle.normal.copyWith(fontSize: 8),
                  ),
                  Text(
                    steps.toValue(),
                    style: War9aTextstyle.blackW600Font16.copyWith(fontSize: 8),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
