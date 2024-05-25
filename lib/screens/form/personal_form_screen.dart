import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/user.dart';
import '../../repository/auth_repository.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import '../login/login_screen.dart';
import 'components/box_info.dart';
import 'components/form_personal_data.dart';
import 'cubit/personal_form_cubit.dart';

class PersonalFormScreen extends StatefulWidget {
  final bool fromSplashScreen;
  const PersonalFormScreen({super.key, this.fromSplashScreen = false});

  @override
  State<PersonalFormScreen> createState() => _PersonalFormScreenState();
}

class _PersonalFormScreenState extends State<PersonalFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final LoadingDialog _loadingDialog;
  late final PersonalFormCubit _personalFormCubit;

  @override
  void initState() {
    super.initState();
    final AuthRepository authRepository = getIt<AuthRepository>();
    _loadingDialog = getIt<LoadingDialog>();
    _personalFormCubit =
        safeRegisterSingleton(PersonalFormCubit(authRepository));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppbarWidget(
        '',
        backColor: Colors.black,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        showBackButton: !widget.fromSplashScreen,
      ),
      body: BlocListener<PersonalFormCubit, PersonalFormState>(
        bloc: _personalFormCubit,
        listener: (context, state) {
          _loadingDialog.show(context, state.isLoading);

          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
            AppRoute.clearTopTo(const LoginScreen());
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
        },
        child: Stack(
          children: [
            Assets.images.backgroundPersonalForm.image(
                width: context.mediaSize.width,
                height: context.mediaSize.height,
                fit: BoxFit.fill,
                alignment: Alignment.centerRight),
            ListWidget(
              _contents,
              isSeparated: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, item, index) => item,
              separatorBuilder: (context, item, index) =>
                  const SpacerWidget(16),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> get _contents => [
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Text("Lengkapi Data Diri", style: War9aTextstyle.title),
        ),
        const BoxInfo(),
        FormPersonalData(_formKey),
        Button(
          "Simpan",
          width: context.mediaSize.width,
          elevation: 8,
          onPressed: onSaveData,
        ),
      ];

  void onSaveData() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();
    final user = User.fromJson(formKeyState.value);
    _personalFormCubit.addUser(user);
  }
}
