import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/pengajuan_surat.dart';
import '../../utils/export_utils.dart';
import '../preview_pengajuan/preview_pengajuan_screen.dart';
import 'components/form_pengajuan_surat.dart';
import 'cubit/form_pengajuan_surat_cubit.dart';

class FormPengajuanSuratScreen extends StatefulWidget {
  final PengajuanSurat? pengajuanSurat;
  const FormPengajuanSuratScreen({super.key, this.pengajuanSurat});

  @override
  State<FormPengajuanSuratScreen> createState() =>
      _FormPengajuanSuratScreenState();
}

class _FormPengajuanSuratScreenState extends State<FormPengajuanSuratScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final FormPengajuanSuratCubit _cubit;
  PengajuanSurat? _pengajuanSurat;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<FormPengajuanSuratCubit>();
    _cubit.initial(widget.pengajuanSurat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("Form Pengajuan Surat"),
      body: ListWidget(
        _contents,
        isSeparated: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (BuildContext context, Widget item, int index) => item,
        separatorBuilder: (BuildContext context, Widget item, int index) =>
            const SpacerWidget(8),
      ),
    );
  }

  List<Widget> get _contents => [
        BlocSelector<FormPengajuanSuratCubit, FormPengajuanSuratState,
                PengajuanSurat?>(
            bloc: _cubit,
            selector: (state) => state.pengajuanSurat,
            builder: (context, state) {
              _pengajuanSurat = state;
              return FormPengajuanSurat(_formKey, pengajuanSurat: state);
            }),
        const SpacerWidget(8),
        Button(
          "Ajukan Surat",
          onPressed: onSubmit,
          height: 52,
        )
      ];

  void onSubmit() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();
    logger.d(formKeyState.value);
    final formResult = PengajuanSurat.fromJson(formKeyState.value);
    final pengajuanSurat = formResult.copyWith(
        rt: _pengajuanSurat?.rt, from: _pengajuanSurat?.from);
    logger.d(pengajuanSurat);
    AppRoute.to(PreviewPengajuanScreen(pengajuanSurat: pengajuanSurat));
  }
}
