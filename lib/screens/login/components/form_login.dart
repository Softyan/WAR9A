import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../components/textfield.dart';

typedef OnViewPassword = Function();

class FormLogin extends StatelessWidget {
  final Key? formKey;
  final bool isHiddenPassword;
  final OnViewPassword onViewPassword;
  const FormLogin(
      {super.key,
      this.formKey,
      required this.isHiddenPassword,
      required this.onViewPassword});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppTextField(
                'email',
                label: 'Email',
                hint: 'jhondoe@email.com',
                validateMode: AutovalidateMode.onUserInteraction,
                validators: [FormBuilderValidators.email()],
              ),
              const SizedBox(height: 8),
              AppTextField(
                'password',
                label: 'Password',
                validateMode: AutovalidateMode.onUserInteraction,
                isObscureText: isHiddenPassword,
                suffixIcon: IconButton(
                    onPressed: onViewPassword,
                    icon: Icon(isHiddenPassword
                        ? Icons.remove_red_eye
                        : Icons.visibility_off)),
                validators: [
                  FormBuilderValidators.minLength(8),
                  FormBuilderValidators.match(r'\d',
                      errorText: 'Must contain a number'),
                  FormBuilderValidators.match(r'[A-Z]',
                      errorText: 'Must contain an uppercase character'),
                  FormBuilderValidators.match(r'[a-z]',
                      errorText: 'Must contain a lowercase character'),
                ],
              )
            ]));
  }
}
