import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/surat.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'cubit/data_surat_cubit.dart';

class AddDataSuratScreen extends StatefulWidget {
  final Surat? surat;
  const AddDataSuratScreen({super.key, this.surat});

  @override
  State<AddDataSuratScreen> createState() => _AddDataSuratScreenState();
}

class _AddDataSuratScreenState extends State<AddDataSuratScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final DataSuratCubit _dataSuratCubit;
  late final LoadingDialog _loadingDialog;
  late Surat? _newSurat;
  bool _isUpdate = false;

  @override
  void initState() {
    super.initState();
    _dataSuratCubit = getIt<DataSuratCubit>();
    _loadingDialog = getIt<LoadingDialog>();
    _newSurat = widget.surat;
    _isUpdate = _newSurat != null;
    _dataSuratCubit.initial(_newSurat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("${_isUpdate ? "Ubah" : "Tambah"} Data Surat"),
      body: BlocListener<DataSuratCubit, DataSuratState>(
        bloc: _dataSuratCubit,
        listener: (context, state) {
          _formKey.currentState?.fields["image"]?.didChange(state.pathImage);
          _loadingDialog.show(context, state.isLoading);
          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
            AppRoute.back(_isUpdate ? state.surat : true);
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
        },
        child: FormBuilder(
          key: _formKey,
          child: ListWidget(
            _contents,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            isSeparated: true,
            itemBuilder: (BuildContext context, Widget item, int index) => item,
            separatorBuilder: (context, item, index) => const SpacerWidget(16),
          ),
        ),
      ),
    );
  }

  List<Widget> get _contents => [
        TextFieldWidget(
          'from',
          hint: "Jhon Doe",
          label: "Asal Surat",
          initialValue: _newSurat?.from,
        ),
        TextFieldWidget(
          'no_surat',
          hint: "xx/xx/xxxx",
          label: "Nomor Surat",
          initialValue: _newSurat?.noSurat,
        ),
        TextFieldWidget(
          'perihal',
          label: "Perihal",
          initialValue: _newSurat?.perihal,
        ),
        DropdownfieldWidget<bool>(
          'is_surat_masuk',
          const [true, false],
          label: 'Status Surat',
          initialValue: _newSurat?.isSuratMasuk ?? true,
          onItemsBuilder: (stay) => DropdownMenuItem(
              value: stay, child: Text(stay ? "Surat Masuk" : "Surat Keluar")),
          validator: FormBuilderValidators.required(),
        ),
        const Text(
          "Upload Foto",
          style: War9aTextstyle.normal,
        ),
        BlocSelector<DataSuratCubit, DataSuratState, String>(
          bloc: _dataSuratCubit,
          selector: (state) => state.pathImage,
          builder: (context, state) => PickFileWidget(
            "image",
            filePaths: state.isEmpty ? [] : [state],
            pickFile: _dataSuratCubit.pickImageSurat,
          ),
        ),
        const SpacerWidget(8),
        Button(
          !_isUpdate ? "Simpan" : "Edit",
          onPressed: submitDataSurat,
          width: context.mediaSize.width,
        )
      ];

  void submitDataSurat() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    Surat surat = Surat.fromJson(formKeyState.value);
    final filePaths = formKeyState.value['image'];
    surat = surat.copyWith(
        id: _newSurat?.id,
        suratUrls: [filePaths],
        createdAt: _newSurat?.createdAt,
        role: _newSurat?.role,
        rt: _newSurat?.rt);

    logger.d(surat);
    logger.d(_newSurat);
    logger.d("isSame: ${surat == _newSurat}");

    if (surat == _newSurat) {
      context.snackbar.showSnackBar(SnackbarWidget(
          "Data Surat tidak ada perubahan",
          state: SnackbarState.normal));
      AppRoute.back(surat);
      return;
    }

    if (!_isUpdate) {
      _dataSuratCubit.addSurat(surat);
    } else {
      _dataSuratCubit.updateSurat(surat);
    }
  }
}
