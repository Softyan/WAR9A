import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import '../main/cubit/main_screen_cubit.dart';

// TODO : Styling this UI
class NotActiveWargaScreen extends StatelessWidget {
  final MainScreenCubit cubit;
  const NotActiveWargaScreen({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: context.mediaSize.width,
      height: context.mediaSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Container(
            height: 300,
            alignment: Alignment.center,
            child: BlocBuilder<MainScreenCubit, MainScreenState>(
              bloc: cubit,
              builder: (context, state) {
                if (state.isLoading) {
                  return const LoadingWidget();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Assets.images.logo2Primary.svg(),
                    const Text(
                      "Bukan Warga",
                    ),
                    const Text(
                        "Silahkan hubungi ketua rt untuk informasi lebih lanjut"),
                    Button(
                      "Refresh",
                      onPressed: cubit.refreshRole,
                      width: 250,
                    ),
                    TextButton(
                        onPressed: cubit.logOut, child: const Text("LogOut"))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ));
  }
}
