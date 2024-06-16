import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/news.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'components/pick_image_widget.dart';
import 'cubit/add_news_cubit.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final AddNewsCubit _addNewsCubit;
  late final LoadingDialog _loadingDialog;
  List<String> paragraphs = [''];

  @override
  void initState() {
    super.initState();
    _loadingDialog = getIt<LoadingDialog>();
    _addNewsCubit = getIt<AddNewsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("Tambah Berita"),
      body: BlocListener<AddNewsCubit, AddNewsState>(
        bloc: _addNewsCubit,
        listener: (BuildContext context, AddNewsState state) {
          _formKey.currentState?.fields["image"]?.didChange(state.pathImage);

          _loadingDialog.show(context, state.isLoading);

          if (state.isSuccess) {
            _formKey.currentState?.reset();
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
          logger.d(state);
        },
        child: FormBuilder(
          key: _formKey,
          child: ListWidget(
            _contents,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            isSeparated: true,
            itemBuilder: (BuildContext context, Widget item, int index) => item,
            separatorBuilder: (context, item, index) => const SpacerWidget(8),
          ),
        ),
      ),
    );
  }

  List<Widget> get _contents => [
        const Text(
          "Judul Berita",
          style: War9aTextstyle.normal,
        ),
        const TextFieldWidget(
          'title',
          hint: "Title",
        ),
        const Text(
          "Isi Berita",
          style: War9aTextstyle.normal,
        ),
        ListWidget(
          getNewParagraph(),
          shrinkWrap: true,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          isSeparated: true,
          itemBuilder: (context, item, index) => item,
          separatorBuilder: (context, item, index) => const SpacerWidget(8),
        ),
        buttonAdd(),
        const Text(
          "Upload Foto",
          style: War9aTextstyle.normal,
        ),
        BlocSelector<AddNewsCubit, AddNewsState, String>(
          bloc: _addNewsCubit,
          selector: (state) => state.pathImage,
          builder: (context, state) => FormBuilderField<String>(
            name: 'image',
            validator: FormBuilderValidators.required(),
            builder: (FormFieldState<String> field) => InputDecorator(
              decoration: InputDecoration(
                border: InputBorder.none,
                errorText: field.errorText,
              ),
              child: PickImageWidget(
                imageFile: state,
                pickImage: _addNewsCubit.pickImage,
              ),
            ),
          ),
        ),
        const SpacerWidget(16),
        Button("Submit", onPressed: submitNews)
      ];

  void submitNews() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();
    News news = News.fromJson(formKeyState.value);
    final contents = paragraphs.where((e) => e.isNotEmpty).toList();
    news = news.copyWith(contents: contents);
    logger.d(news.toInsertNews);
    _addNewsCubit.addNews(news);
  }

  List<Widget> getNewParagraph() {
    List<Widget> textFields = [];
    for (var i = 0; i < paragraphs.length; i++) {
      final paragraph = paragraphs[i];
      _formKey.currentState?.fields['paragraph_$i']?.didChange(paragraph);
      textFields.add(_contentsBerita(i));
    }
    return textFields;
  }

  Widget _contentsBerita(int i) => Row(
        children: [
          Expanded(
              flex: 2,
              child: TextFieldWidget(
                'paragraph_$i',
                hint: "Content ${i + 1}",
                keyboardType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
                disableValidator: i != 0,
                onChanged: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    paragraphs[i] = '';
                    setState(() {});
                    return;
                  }
                  setState(() {
                    paragraphs[i] = p0.trim();
                  });
                },
              )),
          paragraphs.length == 1
              ? Container()
              : Container(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          paragraphs.removeAt(i);
                        });
                      },
                      icon: const Icon(Icons.close)))
        ],
      );

  Widget buttonAdd() {
    if (paragraphs.length == 5) return Container();
    return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        color: War9aColors.primaryColor,
        padding: EdgeInsets.zero,
        dashPattern: const [10, 5],
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              paragraphs.add('');
            });
          },
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              color: War9aColors.primaryColor,
            ),
          ),
        ));
  }
}
