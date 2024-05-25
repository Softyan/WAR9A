import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/user.dart';
import '../../repository/auth_repository.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import '../form/personal_form_screen.dart';
import 'components/form_register.dart';
import 'cubit/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final RegisterCubit _registerCubit;
  late final LoadingDialog _loadingDialog;

  @override
  void initState() {
    _loadingDialog = getIt<LoadingDialog>();
    final authRepository = getIt<AuthRepository>();
    _registerCubit = safeRegisterSingleton(RegisterCubit(authRepository));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        '',
        backgroundColor: War9aColors.primaryColor,
        backColor: Colors.white,
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
          bloc: _registerCubit,
          listener: (context, state) {
            _loadingDialog.show(context, state.isLoading);

            if (state.isSuccess) {
              context.snackbar.showSnackBar(
                  SnackbarWidget(state.message, state: SnackbarState.success));
              AppRoute.clearTopTo(const PersonalFormScreen());
            }
            if (state.isError) {
              context.snackbar.showSnackBar(
                  SnackbarWidget(state.message, state: SnackbarState.error));
            }
          },
          child: Stack(
            children: [
              Assets.images.backgroundLine.image(
                  width: context.mediaSize.width,
                  height: context.mediaSize.height,
                  alignment: Alignment.centerLeft),
              ListWidget<Widget>(
                contents(),
                isSeparated: true,
                itemBuilder: (BuildContext context, Widget item, int index) {
                  if (index == 0) return item;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: item,
                  );
                },
                separatorBuilder: (context, item, index) =>
                    const SpacerWidget(16),
              )
            ],
          )),
    );
  }

  List<Widget> contents() => [
        const HeaderWidget(
          height: 130,
        ),
        Text("Daftar\nAkun Baru", style: War9aTextstyle.title),
        const SpacerWidget(16),
        FormRegister(_formKey),
        Button(
          "Daftar",
          width: context.mediaSize.width,
          elevation: 8,
          onPressed: onSubmit,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Sudah punya akun? ",
                style: War9aTextstyle.normal,
                children: [
                  TextSpan(
                      text: "Login disini",
                      style: War9aTextstyle.normal.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppRoute.back();
                        })
                ])),
      ];

  void onSubmit() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();
    User user = User.fromJson(formKeyState.value);
    logger.d(user.toJson());
    _registerCubit.register(user);
  }

  @override
  void dispose() {
    super.dispose();
    final formKeyState = _formKey.currentState;
    if (formKeyState != null) {
      formKeyState.deactivate();
      formKeyState.dispose();
    }
    _registerCubit.close();
    getIt.unregister<RegisterCubit>();
  }
}
