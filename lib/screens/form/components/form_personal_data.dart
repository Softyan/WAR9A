import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../../components/export_components.dart';
import '../../../models/user.dart';

class FormPersonalData extends StatelessWidget {
  final Key formKey;
  const FormPersonalData(this.formKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: formKey,
        child: ListWidget(
          forms,
          isSeparated: true,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 0),
          scrollPhysics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, item, index) => item,
          separatorBuilder: (context, item, index) => const SpacerWidget(16),
        ));
  }

  List<Widget> get forms => [
        const TextFieldWidget(
          'name',
          label: 'Nama Lengkap',
          hint: 'Jhon Doe',
          validateMode: AutovalidateMode.onUserInteraction,
        ),
        TextFieldWidget(
          'nik',
          label: 'No. KTP',
          hint: '12345464676868',
          validateMode: AutovalidateMode.onUserInteraction,
          validators: [
            FormBuilderValidators.numeric(),
            FormBuilderValidators.equalLength(16)
          ],
        ),
        Row(children: [
          const Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: TextFieldWidget(
                'alamat',
                label: 'Alamat',
                hint: 'Jln. Melati, No. 0',
                validateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
          ),
          Expanded(
              child: DropdownfieldWidget<int>(
            'rt',
            List.generate(4, (i) => i + 1),
            label: "RT",
            onItemsBuilder: (rt) =>
                DropdownMenuItem(value: rt, child: Text('RT $rt')),
            validator: FormBuilderValidators.required(),
          ))
        ]),
        FormBuilderDateTimePicker(
          name: 'birth_day',
          inputType: InputType.date,
          format: DateFormat('dd MMM yyyy'),
          decoration: const InputDecoration(
            labelText: "Tanggal Lahir",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(width: 2),
            ),
          ),
          validator: FormBuilderValidators.required(),
        ),
        DropdownfieldWidget<JenisKelamin>(
          'jenis_kelamin',
          JenisKelamin.values,
          label: 'Gender',
          onItemsBuilder: (gender) => DropdownMenuItem(
              value: gender, child: Text(genderMapping(gender))),
          validator: FormBuilderValidators.required(),
        ),
      ];

  String genderMapping(JenisKelamin gender) {
    return switch (gender) {
      JenisKelamin.man => "Laki - Laki",
      JenisKelamin.women => "Perempuan"
    };
  }
}
