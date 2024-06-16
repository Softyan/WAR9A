import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../res/export_res.dart';
import '../../utils/app_context.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = getIt<HomeCubit>();
    _homeCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "",
        showBackButton: false,
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: War9aColors.primaryColor,
            statusBarIconBrightness: Brightness.light),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: _homeCubit,
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }
          return RefreshIndicator.adaptive(
            onRefresh: () async => _homeCubit.init(),
            child: ListWidget(
              state.contents,
              isSeparated: true,
              padding: const EdgeInsets.only(bottom: 8),
              itemBuilder: (context, item, index) => item,
              separatorBuilder: (context, item, index) =>
                  const SpacerWidget(16),
            ),
          );
        },
      ),
    );
  }
}
