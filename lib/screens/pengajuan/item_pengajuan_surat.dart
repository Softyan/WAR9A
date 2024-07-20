import 'package:flutter/material.dart';

import '../../models/enums/role.dart';
import '../../models/enums/steps.dart';
import '../../models/pengajuan_surat.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import '../preview_pengajuan/preview_pengajuan_screen.dart';
import '../signature/signature_screen.dart';

class ItemPengajuanSurat extends StatelessWidget {
  final PengajuanSurat pengajuanSurat;
  final int index;
  final Role role;
  final void Function()? onRefresh;
  const ItemPengajuanSurat(
      {super.key,
      required this.pengajuanSurat,
      required this.index,
      this.role = Role.warga,
      this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final PengajuanSurat(:name, :steps, :keperluan) = pengajuanSurat;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _onClick,
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

  void _onClick() {
    final status = pengajuanSurat.steps;
    logger.d("Role: $role");
    if (role == Role.warga) {
      if (status == Steps.pengajuan) {
        AppRoute.to(PreviewPengajuanScreen(
          pengajuanSurat: pengajuanSurat,
          isPreview: status == Steps.pengajuan,
          refreshBack: true,
          role: role,
        )).then((value) => onRefresh?.call());
      }
      if (status == Steps.ttdRw || status == Steps.diterima) {
        AppRoute.to(PreviewPengajuanScreen(
          pengajuanSurat: pengajuanSurat.copyWith(steps: Steps.diterima),
          refreshBack: true,
          role: role,
          updateStatusPengajuan: status != Steps.diterima,
        )).then((value) => onRefresh?.call());
      }
      return;
    }

    if (role == Role.rt) {
      if (status != Steps.pengajuan) {
        AppRoute.to(PreviewPengajuanScreen(
          pengajuanSurat: pengajuanSurat,
          isPreview: true,
          refreshBack: true,
          role: role,
        )).then((value) => onRefresh?.call());
        return;
      }
    }

    if (role == Role.rw) {
      if (status != Steps.ttdRt) {
        AppRoute.to(PreviewPengajuanScreen(
          pengajuanSurat: pengajuanSurat,
          isPreview: true,
          refreshBack: true,
          role: role,
        )).then((value) => onRefresh?.call());
        return;
      }
    }

    AppRoute.to(SignatureScreen(
      pengajuanSurat: pengajuanSurat,
    )).then((value) => onRefresh?.call());
  }
}
