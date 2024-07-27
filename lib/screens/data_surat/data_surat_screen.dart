import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../components/form/choice_chip_widget.dart';
import '../../di/injection.dart';
import '../../models/surat.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'add_data_surat_screen.dart';
import 'cubit/data_surat_cubit.dart';
import 'detail_data_surat_screen.dart';
import 'item_surat.dart';

class DataSuratScreen extends StatefulWidget {
  const DataSuratScreen({super.key});

  @override
  State<DataSuratScreen> createState() => _DataSuratScreenState();
}

class _DataSuratScreenState extends State<DataSuratScreen> {
  late final DataSuratCubit _dataSuratCubit;
  String? _query;
  bool _isSuratMasuk = true;

  @override
  void initState() {
    super.initState();
    _dataSuratCubit = getIt<DataSuratCubit>();
    _dataSuratCubit.getDataSurat(isSuratMasuk: _isSuratMasuk, query: _query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Data Surat",
        backgroundColor: context.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(
                onSubmitted: (String query) {
                  _query = query;
                  _dataSuratCubit.getDataSurat(
                      isSuratMasuk: _isSuratMasuk, query: _query);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChipWidget(
                      "Surat Masuk",
                      _isSuratMasuk == true,
                      onSelected: (value) {
                        setState(() => _isSuratMasuk = true);
                        _dataSuratCubit.getDataSurat(
                            isSuratMasuk: true, query: _query);
                      },
                    ),
                    ChoiceChipWidget(
                      "Surat Keluar",
                      _isSuratMasuk == false,
                      onSelected: (value) {
                        setState(() => _isSuratMasuk = false);
                        _dataSuratCubit.getDataSurat(
                            isSuratMasuk: false, query: _query);
                      },
                    ),
                  ],
                ),
              )
            ],
          )),
          Expanded(
              flex: 5,
              child: BlocBuilder<DataSuratCubit, DataSuratState>(
                bloc: _dataSuratCubit,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const LoadingWidget();
                  }

                  if (state.surats.isEmpty) {
                    return EmptyDataWidget(
                      onClick: () => _dataSuratCubit.getDataSurat(
                          isSuratMasuk: _isSuratMasuk, query: _query),
                    );
                  }
                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      _dataSuratCubit.getDataSurat(
                          isSuratMasuk: _isSuratMasuk, query: _query);
                      Future.delayed(const Duration(seconds: 2));
                    },
                    child: ListWidget(state.surats,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemBuilder:
                            (BuildContext context, Surat item, int index) {
                      return ItemSurat(
                        surat: item,
                        index: (index + 1),
                        onClick: () => AppRoute.to(
                          DetailDataSuratScreen(surat: item),
                        ).then((value) {
                          _dataSuratCubit.getDataSurat(
                              isSuratMasuk: _isSuratMasuk, query: _query);
                        }),
                      );
                    }),
                  );
                },
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _clickAddSurat,
        backgroundColor: War9aColors.primary,
        child: Icon(Icons.add, color: context.backgroundColor),
      ),
    );
  }

  void _clickAddSurat() async {
    final isRefresh = await AppRoute.to(const AddDataSuratScreen());

    if (isRefresh == null || isRefresh is! bool) return;

    if (isRefresh == true) {
      _dataSuratCubit.getDataSurat(isSuratMasuk: _isSuratMasuk, query: _query);
      return;
    }
  }
}
