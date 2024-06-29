import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/item_data_profile.dart';
import '../../models/user.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'components/item_profile.dart';
import 'cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;
  bool isDataWarga = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>();
    final user = widget.user;
    isDataWarga = user != null;
    _cubit.getUser(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        isDataWarga ? "Detail Data Warga" : "Profile",
        showBackButton: false,
        backgroundColor: context.backgroundColor,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }
          return ListWidget(
            _contents,
            isSeparated: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, item, index) => item,
            separatorBuilder: (context, item, index) => const SpacerWidget(16),
          );
        },
      ),
    );
  }

  List<Widget> get _contents => [
        SizedBox(
            width: context.mediaSize.width,
            height: 150,
            child: Assets.images.profile.image()),
        ListWidget(
          _dataProfile(_cubit.state.user),
          shrinkWrap: true,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, item, index) => ItemProfile(
            dataProfile: item,
          ),
        ),
        Button(
          isDataWarga ? "Hapus Data" : "LogOut",
          onPressed: () => isDataWarga
              ? _cubit.hapusDataWarga(_cubit.state.user)
              : _cubit.logOut(),
          width: context.mediaSize.width,
          backgroundColor: War9aColors.red,
          textStyle: War9aTextstyle.blackW600Font16
              .copyWith(fontSize: 18, color: Colors.white),
        )
      ];

  List<ItemDataProfile> _dataProfile(User user) {
    final User(:name, :nik, :alamat, :rt, :birthDate) = user;
    return [
      ItemDataProfile(
          title: "Nama", content: name, path: Assets.icons.icNama.path),
      ItemDataProfile(
          title: "NIK", content: nik, path: Assets.icons.icNoKtp.path),
      ItemDataProfile(
          title: "Alamat", content: alamat, path: Assets.icons.icAlamat.path),
      ItemDataProfile(
          title: "Tanggal Lahir",
          content: birthDate?.formattedDate(pattern: 'dd MMMM yyyy') ?? '-',
          path: Assets.icons.icBirthday.path),
      ItemDataProfile(
          title: "Rukun Tetangga",
          content: "0$rt",
          path: Assets.icons.icRt.path),
    ];
  }
}
