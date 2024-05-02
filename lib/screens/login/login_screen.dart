import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/user.dart';
import '../../repository/auth_repository.dart';
import '../../utils/app_context.dart';
import '../../utils/app_route.dart';
import '../../utils/logger.dart';
import '../home/home_screen.dart';
import 'components/form_login.dart';
import 'components/header_widget.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final LoginCubit _loginCubit;
  var isHiddenPassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        bloc: _loginCubit,
        listener: (context, state) {
          // TODO: implement listener
        },
        child: Column(
          children: [
            const Expanded(child: HeaderWidget()),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Login"),
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
                    const AppSpacer(32),
                  ],
                ),
              ),
            ),
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
    _loginCubit.login(email, password);
  }

  @override
  void dispose() {
    _loginCubit.close();
    getIt.unregister<LoginCubit>();
    super.dispose();
  }
}
