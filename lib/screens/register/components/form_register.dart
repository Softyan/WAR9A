import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../components/textfield_widget.dart';

typedef OnViewPassword = void Function();

class FormRegister extends StatefulWidget {
  final Key? formKey;
  const FormRegister(
    this.formKey, {
    super.key,
  });

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  String? password;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFieldWidget(
              'email',
              label: 'Email',
              hint: 'jhondoe@email.com',
              validateMode: AutovalidateMode.onUserInteraction,
              validators: [FormBuilderValidators.email()],
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              'password',
              label: 'Password',
              validateMode: AutovalidateMode.onUserInteraction,
              isObscureText: isHiddenPassword,
              maxLines: 1,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHiddenPassword = !isHiddenPassword;
                    });
                  },
                  icon: Icon(isHiddenPassword
                      ? Icons.remove_red_eye
                      : Icons.visibility_off)),
              onChanged: (p0) => setState(() {
                password = p0;
              }),
              validators: [
                FormBuilderValidators.minLength(8),
                FormBuilderValidators.match(r'\d',
                    errorText: 'Must contain a number'),
                FormBuilderValidators.match(r'[A-Z]',
                    errorText: 'Must contain an uppercase character'),
                FormBuilderValidators.match(r'[a-z]',
                    errorText: 'Must contain a lowercase character'),
              ],
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              'confirm_password',
              label: 'Confirm Password',
              validateMode: AutovalidateMode.onUserInteraction,
              maxLines: 1,
              isObscureText: isHiddenConfirmPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHiddenConfirmPassword = !isHiddenConfirmPassword;
                    });
                  },
                  icon: Icon(isHiddenConfirmPassword
                      ? Icons.remove_red_eye
                      : Icons.visibility_off)),
              validators: [
                FormBuilderValidators.match(password ?? '',
                    errorText: 'Must same as password'),
              ],
            )
          ],
        ));
  }
}
