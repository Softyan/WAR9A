import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/surat.dart';
import '../../res/war9a_colors.dart';
import '../../utils/export_utils.dart';
import 'cubit/pengajuan_surat_cubit.dart';

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
      body: Stack(
        children: [
          BlocBuilder<PengajuanSuratCubit, PengajuanSuratState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state.isLoading) {
                return const LoadingWidget();
              }
              if (state.listSurat.isEmpty) {
                return EmptyDataWidget(
                  onClick: () => _cubit.getPengajuanSurat(),
                );
              }
              return RefreshIndicator.adaptive(
                  child: ListWidget(
                    state.listSurat,
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        top: 70, bottom: 8, right: 16, left: 16),
                    itemBuilder:
                        (BuildContext context, Surat item, int index) =>
                            ItemSurat(
                      surat: item,
                      index: (index + 1),
                      fromDataSurat: false,
                    ),
                  ),
                  onRefresh: () async => _cubit.getPengajuanSurat());
            },
          ),
          SearchWidget(
            onSubmitted: (String query) {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        backgroundColor: War9aColors.primary,
        child: Icon(Icons.add, color: context.backgroundColor),
      ),
    );
  }
}
