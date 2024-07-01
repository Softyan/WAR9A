import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TextFieldWidget extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final bool isObscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<String? Function(String?)>? validators;
  final Function(String?)? onChanged;
  final Widget? suffixIcon;
  final String? initialValue;
  final AutovalidateMode? validateMode;
  final double? borderRadius;
  final int? maxLines;
  final TextInputAction? inputAction;
  final bool disableValidator;
  final bool enabled;
  const TextFieldWidget(this.name,
      {super.key,
      this.label,
      this.hint,
      this.isObscureText = false,
      this.keyboardType = TextInputType.text,
      this.textCapitalization = TextCapitalization.none,
      this.validators,
      this.onChanged,
      this.suffixIcon,
      this.initialValue,
      this.validateMode,
      this.borderRadius,
      this.maxLines,
      this.inputAction = TextInputAction.next,
      this.enabled = true,
      this.disableValidator = false});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      autovalidateMode: validateMode,
      initialValue: initialValue,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      textInputAction: inputAction,
      obscureText: isObscureText,
      style: TextStyle(
        color: enabled ? Colors.black : null,
      ),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16)),
          borderSide: const BorderSide(width: 2),
        ),
        hintText: hint,
      ),
      validator: disableValidator
          ? null
          : FormBuilderValidators.compose(_getValidators(validators)),
      onChanged: onChanged,
    );
  }

  List<FormFieldValidator<String>> _getValidators(
      List<String? Function(String? p1)>? validators) {
    List<FormFieldValidator<String>> listValidators = [];
    listValidators.add(
      FormBuilderValidators.required(),
    );
    if (validators != null && validators.isNotEmpty) {
      listValidators.addAll(validators);
    }

    return listValidators;
  }
}
