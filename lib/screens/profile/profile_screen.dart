import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/enums/profile_type.dart';
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
  bool isForProfile = true;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>();
    final user = widget.user;
    isForProfile = user == null;
    _cubit.getUser(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        isForProfile ? "Profile" : "Detail Data Warga",
        showBackButton: false,
        backgroundColor: context.backgroundColor,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
        },
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
        BlocSelector<ProfileCubit, ProfileState, ProfileType>(
            bloc: _cubit,
            selector: (state) => state.profileType,
            builder: (context, state) => Button(
                  _titleButton(state),
                  onPressed: () => isForProfile
                      ? _cubit.logOut()
                      : _cubit.changeStatusDataWarga(_cubit.state.user),
                  width: context.mediaSize.width,
                  backgroundColor: state == ProfileType.active
                      ? War9aColors.green
                      : War9aColors.red,
                  textStyle: War9aTextstyle.blackW600Font16
                      .copyWith(fontSize: 18, color: Colors.white),
                ))
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

  String _titleButton(ProfileType profileType) => switch (profileType) {
        ProfileType.active => "Aktifkan",
        ProfileType.deactive => "Deaktifkan",
        ProfileType.logOut => "LogOut",
      };
}
