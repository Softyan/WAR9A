import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/news.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'cubit/add_news_cubit.dart';

class AddNewsScreen extends StatefulWidget {
  final News? news;
  const AddNewsScreen({super.key, this.news});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final AddNewsCubit _addNewsCubit;
  late final LoadingDialog _loadingDialog;
  late List<String> _paragraphs;
  News? _news;

  @override
  void initState() {
    super.initState();
    _loadingDialog = getIt<LoadingDialog>();
    _addNewsCubit = getIt<AddNewsCubit>();
    _news = widget.news;
    _addNewsCubit.initial(_news);
    _paragraphs = _news?.contents ?? [''];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("${_news == null ? "Tambah" : "Edit"} Berita"),
      body: BlocListener<AddNewsCubit, AddNewsState>(
        bloc: _addNewsCubit,
        listener: (BuildContext context, AddNewsState state) {
          _formKey.currentState?.fields["image"]?.didChange(state.pathImage);

          _loadingDialog.show(context, state.isLoading);

          if (state.isSuccess) {
            _formKey.currentState?.reset();
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
            AppRoute.back(state.news);
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
        TextFieldWidget(
          'title',
          initialValue: _news?.title,
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
            builder: (context, state) => PickFileWidget(
                  "image",
                  filePaths: state.isEmpty ? [] : [state],
                  pickFile: _addNewsCubit.pickImage,
                )),
        const SpacerWidget(16),
        Button(_news == null ? "Submit" : "Update", onPressed: submitNews)
      ];

  void submitNews() {
    final formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();
    News news = News.fromJson(formKeyState.value);
    var contents = _paragraphs.where((e) => e.isNotEmpty).toList();
    contents = contents.map((e) => e.clearMultipleSpaces()).toList();
    news = news.copyWith(
        id: _news?.id, contents: contents, createdAt: _news?.createdAt);

    logger.d(news.toInsertNews);
    logger.d(news.toString());
    logger.d(_news.toString());
    logger.d("isSame: ${news == _news}");

    if (news == _news) {
      context.snackbar.showSnackBar(SnackbarWidget("Tidak ada perubahan data",
          state: SnackbarState.normal));
      AppRoute.back();
      return;
    }

    if (_news == null) {
      _addNewsCubit.addNews(news);
    } else {
      _addNewsCubit.updateNews(news);
    }
  }

  List<Widget> getNewParagraph() {
    List<Widget> textFields = [];
    for (var i = 0; i < _paragraphs.length; i++) {
      final paragraph = _paragraphs[i];
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
                initialValue: _paragraphs[i],
                hint: "Content ${i + 1}",
                keyboardType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
                disableValidator: i != 0,
                onChanged: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    _paragraphs[i] = '';
                    setState(() {});
                    return;
                  }
                  setState(() {
                    _paragraphs[i] = p0;
                  });
                },
              )),
          _paragraphs.length == 1
              ? Container()
              : Container(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _paragraphs.removeAt(i);
                        });
                      },
                      icon: const Icon(Icons.close)))
        ],
      );

  Widget buttonAdd() {
    if (_paragraphs.length == 5) return Container();
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
              _paragraphs.add('');
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
