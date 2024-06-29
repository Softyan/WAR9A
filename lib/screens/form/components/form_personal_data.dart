import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../components/export_components.dart';
import '../../../di/injection.dart';
import '../../../models/enums/jenis_kelamin.dart';
import '../../../res/export_res.dart';
import '../../../utils/global_helpers.dart';

class FormPersonalData extends StatefulWidget {
  final Key formKey;
  const FormPersonalData(this.formKey, {super.key});

  @override
  State<FormPersonalData> createState() => _FormPersonalDataState();
}

class _FormPersonalDataState extends State<FormPersonalData> {
  int selectedRt = 1;
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: widget.formKey,
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
        const TextFieldWidget(
          'alamat',
          label: 'Alamat',
          hint: 'Jln. Melati, No. 0',
          validateMode: AutovalidateMode.onUserInteraction,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rukun Tetangga (RT)",
              style: War9aTextstyle.normal,
            ),
            FormBuilderField<int>(
              builder: (FormFieldState<int> field) => InputDecorator(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorText: field.errorText,
                ),
                child: Wrap(
                  spacing: 16.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: List.generate(4, (i) => i + 1)
                      .map((rt) => GestureDetector(
                            onTap: () => setState(() {
                              selectedRt = rt;
                              field.didChange(rt);
                            }),
                            child: Container(
                              width: 70,
                              height: 40,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: selectedRt == rt
                                      ? War9aColors.primaryColor
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: War9aColors.primaryColor)),
                              child: Text(
                                "0$rt",
                                style: War9aTextstyle.normal.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        selectedRt == rt ? Colors.white : null),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              name: 'rt',
            ),
          ],
        ),
        DatetimePickerWidget(
          'birth_date',
          label: "Tanggal Lahir",
        ),
        DropdownfieldWidget<JenisKelamin>(
          'jenis_kelamin',
          JenisKelamin.values,
          label: 'Gender',
          onItemsBuilder: (gender) => DropdownMenuItem(
              value: gender,
              child: Text(getIt<GlobalHelpers>().genderMapping(gender))),
          validator: FormBuilderValidators.required(),
        ),
      ];
}
