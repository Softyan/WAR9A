import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/enums/role.dart';
import '../../models/pengajuan_surat.dart';
import '../../utils/export_utils.dart';
import '../preview_pengajuan/preview_pengajuan_screen.dart';
import 'cubit/signature_cubit.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key, required this.pengajuanSurat});
  final PengajuanSurat pengajuanSurat;

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final SignatureCubit _signatureCubit;
  late final LoadingDialog _loadingDialog;
  late PengajuanSurat _newPengajuanSurat;

  @override
  void initState() {
    super.initState();
    _loadingDialog = getIt<LoadingDialog>();
    _signatureCubit = getIt<SignatureCubit>();
    _newPengajuanSurat = widget.pengajuanSurat;
    _signatureCubit.init(_newPengajuanSurat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("Form Pengajuan Surat"),
      body: BlocListener<SignatureCubit, SignatureState>(
        bloc: _signatureCubit,
        listener: (context, state) {
          _loadingDialog.show(context, state.isLoading);
          final ttdPaths = state.filePaths;

          if (ttdPaths.isNotEmpty) {
            _formKey.currentState?.fields["ttd"]
                ?.didChange(state.filePaths.first);
          }

          _newPengajuanSurat = state.pengajuanSurat;

          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
        },
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  "no_surat",
                  initialValue: _newPengajuanSurat.noSurat,
                  label: "Nomor Surat",
                  hint: "xx/xx/xxxx",
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Tanda Tangan"),
                ),
                BlocSelector<SignatureCubit, SignatureState, List<String>>(
                  bloc: _signatureCubit,
                  selector: (state) => state.filePaths,
                  builder: (context, state) {
                    return PickFileWidget(
                      "ttd",
                      filePaths: state,
                      pickFile: _signatureCubit.pickSignature,
                    );
                  },
                ),
                const SpacerWidget(16),
                BlocSelector<SignatureCubit, SignatureState, Role>(
                  bloc: _signatureCubit,
                  selector: (state) => state.role,
                  builder: (context, state) => Button(
                    "Simpan",
                    onPressed: () => _onSubmit(state),
                    width: context.mediaSize.width,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(Role role) {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    logger.d(formKeyState.value);
    var newPengajuanSurat = _newPengajuanSurat.copyWith(
      noSurat: formKeyState.value["no_surat"].toString().trim(),
    );

    logger.d("role: $role");

    if (role == Role.rt) {
      newPengajuanSurat =
          newPengajuanSurat.copyWith(ttdRt: formKeyState.value["ttd"]);
    }

    if (role == Role.rw) {
      newPengajuanSurat =
          newPengajuanSurat.copyWith(ttdRw: formKeyState.value["ttd"]);
    }

    logger.d("newPengajuanSurat: $newPengajuanSurat");

    AppRoute.to(PreviewPengajuanScreen(
      pengajuanSurat: newPengajuanSurat,
      role: role,
    ));
  }
}
