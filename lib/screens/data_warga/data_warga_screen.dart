import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/user.dart';
import '../../repository/warga_repository.dart';
import '../../utils/export_utils.dart';
import 'components/item_data_warga.dart';
import 'cubit/data_warga_cubit.dart';

class DataWargaScreen extends StatefulWidget {
  const DataWargaScreen({super.key});

  @override
  State<DataWargaScreen> createState() => _DataWargaScreenState();
}

class _DataWargaScreenState extends State<DataWargaScreen> {
  late final DataWargaCubit _dataWargaCubit;
  String? query;

  @override
  void initState() {
    super.initState();
    final WargaRepository wargaRepository = getIt<WargaRepository>();
    _dataWargaCubit = safeRegisterSingleton(DataWargaCubit(wargaRepository));
    _dataWargaCubit.getDataWarga();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Data Warga",
        backgroundColor: context.backgroundColor,
      ),
      body: Column(
        children: [
          SearchWidget(
            onSubmitted: (String query) {
              this.query = query;
              _dataWargaCubit.getDataWarga(search: query);
            },
          ),
          Expanded(
            child: BlocConsumer<DataWargaCubit, DataWargaState>(
              bloc: _dataWargaCubit,
              builder: (context, state) {
                if (state.isLoading) {
                  return const LoadingWidget();
                }
                if (state.users.isEmpty) {
                  return EmptyDataWidget(
                    onClick: () => _dataWargaCubit.getDataWarga(search: query),
                  );
                }
                return RefreshIndicator.adaptive(
                  onRefresh: () async =>
                      _dataWargaCubit.getDataWarga(search: query),
                  child: ListWidget(
                    state.users,
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.only(bottom: 8, right: 16, left: 16),
                    itemBuilder: (BuildContext context, User item, int index) =>
                        ItemDataWarga(user: item, index: (index + 1)),
                  ),
                );
              },
              listener: (context, state) {
                if (state.isError) {
                  context.snackbar.showSnackBar(SnackbarWidget(state.message,
                      state: SnackbarState.error));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
