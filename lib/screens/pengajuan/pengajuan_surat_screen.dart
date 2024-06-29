import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/pengajuan_surat.dart';
import '../../res/war9a_colors.dart';
import '../../utils/export_utils.dart';
import '../form_surat/form_pengajuan_surat_screen.dart';
import '../preview_pengajuan/preview_pengajuan_screen.dart';
import 'cubit/pengajuan_surat_cubit.dart';
import 'item_pengajuan_surat.dart';

class PengajuanSuratScreen extends StatefulWidget {
  const PengajuanSuratScreen({super.key});

  @override
  State<PengajuanSuratScreen> createState() => _PengajuanSuratScreenState();
}

class _PengajuanSuratScreenState extends State<PengajuanSuratScreen> {
  late final PengajuanSuratCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PengajuanSuratCubit>();
    _cubit.getPengajuanSurat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Pengajuan Surat",
        backgroundColor: context.backgroundColor,
      ),
      body: Column(
        children: [
          SearchWidget(
            onSubmitted: (String query) {},
          ),
          Expanded(
            child: BlocBuilder<PengajuanSuratCubit, PengajuanSuratState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state.isLoading) {
                  return const LoadingWidget();
                }
                if (state.pengajuanSurats.isEmpty) {
                  return EmptyDataWidget(
                    onClick: () => _cubit.getPengajuanSurat(),
                  );
                }
                return RefreshIndicator.adaptive(
                    child: ListWidget(
                      state.pengajuanSurats,
                      padding:
                          const EdgeInsets.only(bottom: 8, right: 16, left: 16),
                      itemBuilder: (BuildContext context, PengajuanSurat item,
                          int index) {
                        return ItemPengajuanSurat(
                          pengajuanSurat: item,
                          index: (index + 1),
                          onClick: () => AppRoute.to(PreviewPengajuanScreen(
                            pengajuanSurat: item,
                            isPreview: true,
                          )),
                        );
                      },
                    ),
                    onRefresh: () async => _cubit.getPengajuanSurat());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => AppRoute.to(const FormPengajuanSuratScreen())
            .then((value) => _cubit.getPengajuanSurat()),
        backgroundColor: War9aColors.primary,
        child: Icon(Icons.add, color: context.backgroundColor),
      ),
    );
  }
}
