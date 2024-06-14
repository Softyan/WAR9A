import 'package:flutter/material.dart';

import '../../../models/item_dashboard.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';
import '../../data_surat/data_surat_screen.dart';
import '../../data_warga/data_warga_screen.dart';
import '../../pengajuan/pengajuan_surat_screen.dart';
import 'item_menu.dart';

class MenuDashboard extends StatelessWidget {
  const MenuDashboard({super.key});

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

  List<ItemDashboard> get contents => [
        ItemDashboard(
            title: "Pengajuan Surat",
            path: Assets.icons.pengajuanSurat.path,
            destination: const PengajuanSuratScreen()),
        ItemDashboard(
            title: "Data Warga",
            path: Assets.icons.dataWarga.path,
            destination: const DataWargaScreen()),
        ItemDashboard(
            title: "Data Surat",
            path: Assets.icons.dataSurat.path,
            destination: const DataSuratScreen()),
      ];
}
