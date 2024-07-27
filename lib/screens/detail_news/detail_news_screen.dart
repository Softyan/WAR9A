import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/enums/role.dart';
import '../../models/news.dart';
import '../../repository/shared_preference_repository.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import '../add_news/add_news_screen.dart';
import 'cubit/detail_news_cubit.dart';

class DetailNewsScreen extends StatefulWidget {
  final News news;
  const DetailNewsScreen({super.key, required this.news});

  @override
  State<DetailNewsScreen> createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {
  late final Role role;
  late final DetailNewsCubit _detailNewsCubit;
  late News _news;

  @override
  void initState() {
    super.initState();
    role = getIt<SharedPreferenceRepository>().getRole();
    _detailNewsCubit = getIt<DetailNewsCubit>();
    _news = widget.news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Detail Berita",
        backgroundColor: context.backgroundColor,
      ),
      body: BlocConsumer<DetailNewsCubit, DetailNewsState>(
        bloc: _detailNewsCubit,
        listener: (context, state) {
          if (state.isSuccess) {
            context.snackbar.showSnackBar(
              SnackbarWidget(state.message, state: SnackbarState.success),
            );
            AppRoute.back();
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
              SnackbarWidget(state.message, state: SnackbarState.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }
          return Column(
            children: [
              Expanded(
                child: ListWidget(
                  _contents,
                  isSeparated: true,
                  itemBuilder: (BuildContext context, Widget item, int index) =>
                      Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: item,
                  ),
                  separatorBuilder: (context, item, index) =>
                      const SpacerWidget(8),
                ),
              ),
              role == Role.sekretaris
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Button(
                              "Hapus",
                              onPressed: () =>
                                  _detailNewsCubit.deleteNews(widget.news),
                              borderRadius: 0,
                              height: 50,
                              backgroundColor: War9aColors.red,
                            ),
                          ),
                          Expanded(
                            child: Button(
                              "Edit",
                              onPressed: () async {
                                final result = await AppRoute.to(
                                    AddNewsScreen(news: widget.news));
                                setState(() {
                                  _news = result;
                                });
                              },
                              borderRadius: 0,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  List<Widget> get _contents => [
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: _news.title,
            style: War9aTextstyle.blackW600Font16.copyWith(fontSize: 20),
          ),
          const TextSpan(text: '\n'),
          TextSpan(
              text: _news.createdAt?.formattedDate() ?? "-",
              style: War9aTextstyle.normal),
        ])),
        SizedBox(
          height: 200,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: _news.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: War9aColors.greyF2,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Text("Can't loaded Image")),
                ),
              )),
        ),
        ListWidget<String>(
          _news.contents ?? [],
          scrollPhysics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          isSeparated: true,
          separatorBuilder: (context, item, index) => const SpacerWidget(8),
          itemBuilder: (BuildContext context, String item, int index) => Text(
            item,
            textAlign: TextAlign.justify,
            style: War9aTextstyle.normal,
          ),
        ),
      ];
}
