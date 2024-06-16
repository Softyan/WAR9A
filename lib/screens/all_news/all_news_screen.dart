import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/news.dart';
import '../../utils/export_utils.dart';
import '../add_news/add_news_screen.dart';
import '../detail_news/detail_news_screen.dart';
import 'components/item_news.dart';
import 'cubit/all_news_cubit.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({super.key});

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  late final AllNewsCubit _newsCubit;
  String? search;

  @override
  void initState() {
    super.initState();
    _newsCubit = getIt<AllNewsCubit>();
    _newsCubit.getAllNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Berita",
        backgroundColor: context.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              SearchWidget(
                onSubmitted: (String query) {
                  search = query;
                  _newsCubit.getAllNews(search: query);
                },
              ),
              Container(
                width: context.mediaSize.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: AddButton(
                  onClick: () => AppRoute.to(const AddNewsScreen()),
                ),
              )
            ],
          )),
          Expanded(
              flex: 5,
              child: BlocBuilder<AllNewsCubit, AllNewsState>(
                bloc: _newsCubit,
                builder: (BuildContext context, AllNewsState state) {
                  if (state.isLoading) {
                    return const LoadingWidget();
                  }

                  if (state.news.isEmpty) {
                    return EmptyDataWidget(
                      onClick: () => _newsCubit.getAllNews(search: search),
                    );
                  }

                  return RefreshIndicator.adaptive(
                    child: ListWidget(
                      state.news,
                      scrollPhysics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemBuilder:
                          (BuildContext context, News item, int index) =>
                              ItemNews(
                        news: item,
                        index: index + 1,
                        onClick: () =>
                            AppRoute.to(DetailNewsScreen(news: item)),
                      ),
                    ),
                    onRefresh: () async =>
                        _newsCubit.getAllNews(search: search),
                  );
                },
              ))
        ],
      ),
    );
  }
}
