import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/filter_warga.dart';
import '../../models/user.dart';
import '../../repository/warga_repository.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'components/content_filter.dart';
import 'components/item_data_warga.dart';
import 'cubit/data_warga_cubit.dart';

class DataWargaScreen extends StatefulWidget {
  const DataWargaScreen({super.key});

  @override
  State<DataWargaScreen> createState() => _DataWargaScreenState();
}

class _DataWargaScreenState extends State<DataWargaScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final DataWargaCubit _dataWargaCubit;
  String? query;
  int? selectedRt;
  String? domisili;
  FilterWarga? filter;

  @override
  void initState() {
    super.initState();
    final WargaRepository wargaRepository = getIt<WargaRepository>();
    _dataWargaCubit = safeRegisterSingleton(DataWargaCubit(wargaRepository));
    _dataWargaCubit.getDataWarga(filter: filter);
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
          Row(
            children: [
              Expanded(
                child: SearchWidget(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  onSubmitted: (String query) {
                    this.query = query;
                    _dataWargaCubit.getDataWarga(search: query);
                  },
                ),
              ),
              IconButton(
                icon: Assets.icons.icFilter.svg(),
                onPressed: showFilter,
              )
            ],
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
                    onClick: () => _dataWargaCubit.getDataWarga(
                        search: query, filter: filter),
                  );
                }
                return RefreshIndicator.adaptive(
                  onRefresh: () async => _dataWargaCubit.getDataWarga(
                      search: query, filter: filter),
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

  void showFilter() async {
    final result = await showModalBottomSheet<FilterWarga>(
        context: context,
        builder: (BuildContext context) => ContentFilter(
              formKey: _formKey,
              onFilter: filterData,
              selectedRt: selectedRt,
              selectedDomisili: domisili,
              onChangedRt: (int? rt) {
                selectedRt = rt;
              },
              onChangedDomisili: (String? domisili) {
                this.domisili = domisili;
              },
              onReset: () {
                selectedRt = null;
                domisili = null;
                AppRoute.back(const FilterWarga());
              },
            ));

    if (result == null) return;
    filter = result;
    _dataWargaCubit.getDataWarga(search: query, filter: result);
  }

  void filterData() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    final filterWarga = FilterWarga.fromJson(formKeyState.value);

    AppRoute.back(filterWarga);
  }
}
