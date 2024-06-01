import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/item_data_profile.dart';
import '../../models/user.dart';
import '../../res/export_res.dart';
import 'components/item_profile.dart';
import 'cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>();
    _cubit.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Profile",
        showBackButton: false,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        bloc: _cubit,
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Assets.images.profile.image()),
              Expanded(
                  flex: 2,
                  child: ListWidget(
                    _dataProfile(state.user),
                    shrinkWrap: true,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, item, index) => ItemProfile(dataProfile: item,),
                  ))
            ],
          );
        },
      ),
    );
  }

  List<ItemDataProfile> _dataProfile(User user) => [
        ItemDataProfile(title: "Nama", content: user.name),
        ItemDataProfile(title: "NIK", content: user.nik),
        ItemDataProfile(title: "Email", content: user.email),
        ItemDataProfile(title: "Alamat", content: "${user.alamat} (RT ${user.rt})"),
      ];
}
