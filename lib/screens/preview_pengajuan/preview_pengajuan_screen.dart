import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/enums/role.dart';
import '../../models/enums/steps.dart';
import '../../models/pengajuan_surat.dart';
import '../../utils/export_utils.dart';
import '../form_surat/cubit/form_pengajuan_surat_cubit.dart';
import '../main/main_screen.dart';
import 'surat_pengajuan_template.dart';

class PreviewPengajuanScreen extends StatefulWidget {
  final PengajuanSurat pengajuanSurat;
  final bool isPreview;
  final bool refreshBack;
  final Role role;
  final bool updateStatusPengajuan;
  const PreviewPengajuanScreen(
      {super.key,
      required this.pengajuanSurat,
      required this.role,
      this.isPreview = false,
      this.refreshBack = false,
      this.updateStatusPengajuan = false});

  @override
  State<PreviewPengajuanScreen> createState() => _PreviewPengajuanScreenState();
}

class _PreviewPengajuanScreenState extends State<PreviewPengajuanScreen> {
  late final FormPengajuanSuratCubit _pengajuanSuratCubit;
  late final LoadingDialog _loadingDialog;
  late final PengajuanSurat _pengajuanSurat;

  @override
  void initState() {
    super.initState();
    _pengajuanSurat = widget.pengajuanSurat;
    _pengajuanSuratCubit = getIt<FormPengajuanSuratCubit>();
    _loadingDialog = getIt<LoadingDialog>();
    _pengajuanSuratCubit.finishStatusPengajuan(
        _pengajuanSurat, widget.updateStatusPengajuan);
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
            final steps = _pengajuanSurat.steps;

            if (steps == Steps.pengajuan) {
              AppRoute.clearAll(const MainScreen());
            }

            if (steps != Steps.diterima && widget.refreshBack) {
              if (widget.refreshBack) {
                AppRoute.popUntil("Pengajuan Surat");
              } else {
                AppRoute.clearAll(const MainScreen());
              }
            }
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
              build: (PdfPageFormat format) => getIt<SuratPengajuanTemplate>()
                  .suratPengajuanPDf(_pengajuanSurat),
            ),
            widget.isPreview
                ? Container()
                : Builder(builder: (context) {
                    if (_pengajuanSurat.steps == Steps.diterima) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Button(
                            titlePositiveBtn,
                            onPressed: _onSubmit,
                            width: context.mediaSize.width,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Button("Ubah",
                                      onPressed: () =>
                                          AppRoute.back(_pengajuanSurat))),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Button(
                                  titlePositiveBtn,
                                  onPressed: _onSubmit,
                                ),
                              ),
                            ],
                          )),
                    );
                  })
          ],
        ),
      ),
    );
  }

  String get titlePositiveBtn => switch (_pengajuanSurat.steps) {
        Steps.pengajuan => "Ajukan",
        Steps.ttdRt || Steps.ttdRw => "Kirim",
        Steps.diterima => "Download"
      };

  void _onSubmit() => switch (_pengajuanSurat.steps) {
        Steps.pengajuan =>
          _pengajuanSuratCubit.ajukanSuratPengajuan(_pengajuanSurat),
        Steps.ttdRt ||
        Steps.ttdRw =>
          _pengajuanSuratCubit.updateTtdPengajuan(_pengajuanSurat),
        Steps.diterima =>
          _pengajuanSuratCubit.downloadPengajuan(_pengajuanSurat),
      };
}
