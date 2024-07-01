import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/enums/jenis_kelamin.dart';
import '../../models/user.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'cubit/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final ProfileCubit _cubit;
  int currentRt = 0;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>();
    _cubit.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("Edit Profile"),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        bloc: _cubit,
        listener: (context, state) {
          currentRt = state.user.rt;
          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }
          return FormBuilder(
              key: _formKey,
              child: ListWidget(
                _contents(state.user),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                isSeparated: true,
                itemBuilder: (BuildContext context, Widget item, int index) =>
                    item,
                separatorBuilder: (context, item, index) =>
                    const SpacerWidget(16),
              ));
        },
      ),
    );
  }

  void _save() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();
    final user = User.fromJson(formKeyState.value);
    logger.d(user);
    _cubit.updateCurrentUser(user);
  }

  List<Widget> _contents(User user) {
    final User(:name, :nik, :alamat, :rt, :birthDate, :jenisKelamin, :isStay) =
        user;
    return [
      TextFieldWidget(
        'name',
        initialValue: name,
        label: 'Nama Lengkap',
        hint: 'Jhon Doe',
        enabled: false,
        validateMode: AutovalidateMode.onUserInteraction,
      ),
      TextFieldWidget(
        'nik',
        label: 'No. KTP',
        hint: '12345464676868',
        initialValue: nik,
        enabled: false,
        validateMode: AutovalidateMode.onUserInteraction,
        validators: [
          FormBuilderValidators.numeric(),
          FormBuilderValidators.equalLength(16)
        ],
      ),
      TextFieldWidget(
        'alamat',
        label: 'Alamat',
        hint: 'Jln. Melati, No. 0',
        initialValue: alamat,
        validateMode: AutovalidateMode.onUserInteraction,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rukun Tetangga (RT)",
            style: War9aTextstyle.normal,
          ),
          RtPickerWidget(
            "rt",
            initialValue: rt,
          )
        ],
      ),
      DatetimePickerWidget(
        'birth_date',
        label: "Tanggal Lahir",
        initialValue: birthDate,
        enabled: false,
      ),
      DropdownfieldWidget<JenisKelamin>(
        'jenis_kelamin',
        JenisKelamin.values,
        label: 'Gender',
        initialValue: jenisKelamin,
        enabled: false,
        onItemsBuilder: (gender) => DropdownMenuItem(
            value: gender,
            child: Text(getIt<GlobalHelpers>().genderMapping(gender))),
        validator: FormBuilderValidators.required(),
      ),
      DropdownfieldWidget<bool>(
        'is_stay',
        const [true, false],
        label: 'Status Domisili',
        initialValue: isStay,
        onItemsBuilder: (stay) => DropdownMenuItem(
            value: stay, child: Text(stay ? "Menetap" : "Sementara")),
        validator: FormBuilderValidators.required(),
      ),
      Button(
        "Simpan",
        onPressed: _save,
        width: context.mediaSize.width,
      )
    ];
  }
}
