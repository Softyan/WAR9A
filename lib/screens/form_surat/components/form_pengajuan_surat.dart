import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../components/export_components.dart';
import '../../../di/injection.dart';
import '../../../models/enums/jenis_kelamin.dart';
import '../../../models/pengajuan_surat.dart';
import '../../../utils/global_helpers.dart';
import '../../../utils/string_ext.dart';

class FormPengajuanSurat extends StatelessWidget {
  final Key formKey;
  final PengajuanSurat? pengajuanSurat;
  const FormPengajuanSurat(this.formKey, {super.key, this.pengajuanSurat});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: ListWidget(
        _formContent,
        isSeparated: true,
        shrinkWrap: true,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, Widget item, int index) => item,
        separatorBuilder: (BuildContext context, Widget item, int index) =>
            const SpacerWidget(16),
      ),
    );
  }

  List<Widget> get _formContent => [
        TextFieldWidget(
          'name',
          initialValue: pengajuanSurat?.name.capitalEachWord(),
          label: 'Nama Lengkap',
          hint: 'Jhon Doe',
          textCapitalization: TextCapitalization.words,
          validateMode: AutovalidateMode.onUserInteraction,
        ),
        TextFieldWidget(
          'tempat',
          label: "Tempat",
          textCapitalization: TextCapitalization.sentences,
          initialValue: pengajuanSurat?.tempat.capitalEachWord(),
        ),
        DatetimePickerWidget(
          'birth_date',
          label: "Tanggal Lahir",
          initialValue: pengajuanSurat?.birthDate?.toLocal(),
        ),
        DropdownfieldWidget<JenisKelamin>(
          'jenis_kelamin',
          JenisKelamin.values,
          initialValue: pengajuanSurat?.jenisKelamin,
          label: 'Gender',
          onItemsBuilder: (gender) => DropdownMenuItem(
              value: gender,
              child: Text(getIt<GlobalHelpers>().genderMapping(gender))),
          validator: FormBuilderValidators.required(),
        ),
        TextFieldWidget(
          'agama',
          label: "Agama",
          textCapitalization: TextCapitalization.sentences,
          initialValue: pengajuanSurat?.agama.capitalize(),
        ),
        TextFieldWidget(
          'pekerjaan',
          label: "Pekerjaan",
          textCapitalization: TextCapitalization.sentences,
          initialValue: pengajuanSurat?.pekerjaan.capitalize(),
        ),
        TextFieldWidget(
          'nik',
          initialValue: pengajuanSurat?.nik,
          label: 'No. KTP',
          hint: '12345464676868',
          validateMode: AutovalidateMode.onUserInteraction,
          validators: [
            FormBuilderValidators.numeric(),
            FormBuilderValidators.equalLength(16)
          ],
        ),
        TextFieldWidget(
          'alamat',
          initialValue: pengajuanSurat?.alamat.capitalEachWord(),
          label: 'Alamat',
          hint: 'Jln. Melati, No. 0',
          textCapitalization: TextCapitalization.words,
          validateMode: AutovalidateMode.onUserInteraction,
        ),
        TextFieldWidget(
          'keperluan',
          label: "Keperluan",
          textCapitalization: TextCapitalization.sentences,
          initialValue: pengajuanSurat?.keperluan.capitalize(),
        ),
      ];
}
