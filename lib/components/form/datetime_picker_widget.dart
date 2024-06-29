import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class DatetimePickerWidget extends FormBuilderDateTimePicker {
  final String keyName;
  final String? label;
  final String? pattern;
  DatetimePickerWidget(this.keyName,
      {super.key, this.label, this.pattern, super.initialValue})
      : super(
          name: keyName,
          inputType: InputType.date,
          initialDate: initialValue,
          format: DateFormat(pattern ?? 'dd MMM yyyy'),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(width: 2),
            ),
          ),
          validator: FormBuilderValidators.required(),
        );
}
