import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/pengajuan_surat.dart';
import '../../utils/export_utils.dart';
import '../form_surat/cubit/form_pengajuan_surat_cubit.dart';
import 'surat_pengajuan_template.dart';

class PreviewPengajuanScreen extends StatefulWidget {
  final PengajuanSurat pengajuanSurat;
  final bool isPreview;
  const PreviewPengajuanScreen(
      {super.key, required this.pengajuanSurat, this.isPreview = false});

  @override
  State<PreviewPengajuanScreen> createState() => _PreviewPengajuanScreenState();
}

class _PreviewPengajuanScreenState extends State<PreviewPengajuanScreen> {
  late final FormPengajuanSuratCubit _pengajuanSuratCubit;
  late final LoadingDialog _loadingDialog;

  @override
  void initState() {
    super.initState();
    _pengajuanSuratCubit = getIt<FormPengajuanSuratCubit>();
    _loadingDialog = getIt<LoadingDialog>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("Pengajuan Surat"),
      body: BlocListener<FormPengajuanSuratCubit, FormPengajuanSuratState>(
        bloc: _pengajuanSuratCubit,
        listener: (context, state) {
          _loadingDialog.show(context, state.isLoading);

          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
            AppRoute.popUntil("Pengajuan Surat");
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
        },
        child: Stack(
          children: [
            PdfPreview(
              initialPageFormat: PdfPageFormat.a4,
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              canChangeOrientation: false,
              useActions: false,
              build: (PdfPageFormat format) => SuratPengajuanTemplate()
                  .suratPengajuanPDf(widget.pengajuanSurat),
            ),
            widget.isPreview
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                                child: Button("Ubah",
                                    onPressed: () =>
                                        AppRoute.back(widget.pengajuanSurat))),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Button(
                                "Ajukan",
                                onPressed: () =>
                                    _pengajuanSuratCubit.ajukanSuratPengajuan(
                                  widget.pengajuanSurat,
                                ),
                              ),
                            ),
                          ],
                        )),
                  )
          ],
        ),
      ),
    );
  }
}
