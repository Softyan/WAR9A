import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../data/status_auth.dart';
import '../../di/injection.dart';
import '../../models/user.dart';
import '../../repository/auth_repository.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import '../form/personal_form_screen.dart';
import '../main/main_screen.dart';
import '../register/register_screen.dart';
import 'components/form_login.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final LoginCubit _loginCubit;
  late final LoadingDialog _loadingDialog;
  var isHiddenPassword = true;

  @override
  void initState() {
    super.initState();
    _loadingDialog = getIt<LoadingDialog>();
    final authRepository = getIt<AuthRepository>();
    _loginCubit = safeRegisterSingleton(LoginCubit(authRepository));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        bloc: _loginCubit,
        listener: (context, state) {
          _loadingDialog.show(context, state.isLoading);
          if (state.statusAuth == StatusAuth.preFillForm) {
            AppRoute.clearTopTo(const PersonalFormScreen());
          }
          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
            AppRoute.clearAll(const MainScreen());
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
            Column(
              children: [
                const Expanded(child: HeaderWidget()),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: War9aTextstyle.title,
                        ),
                        FormLogin(
                            formKey: _formKey,
                            isHiddenPassword: isHiddenPassword,
                            onViewPassword: () => setState(() {
                                  isHiddenPassword = !isHiddenPassword;
                                })),
                        Button(
                          "Login",
                          width: context.mediaSize.width,
                          elevation: 8,
                          onPressed: onSubmit,
                        ),
                        Center(
                          child: RichText(
                              text: TextSpan(
                                  text: "Belum punya akun? ",
                                  style: War9aTextstyle.normal,
                                  children: [
                                TextSpan(
                                    text: "Daftar disini",
                                    style: War9aTextstyle.normal.copyWith(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        AppRoute.to(const RegisterScreen());
                                      })
                              ])),
                        ),
                        const SpacerWidget(32),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();
    final User(:email, :password) = User.fromJson(formKeyState.value);
    _loginCubit.login(email, password ?? '');
  }

  @override
  void dispose() async {
    super.dispose();
    final formKeyState = _formKey.currentState;
    if (formKeyState != null) {
      formKeyState.deactivate();
      formKeyState.dispose();
    }
    // TODO: Masih ada bug disini
    // await _loginCubit.close();
    // await getIt.unregister<LoginCubit>(
    //   instance: _loginCubit,
    // );
  }
}
