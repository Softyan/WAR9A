part of 'all_news_cubit.dart';

@MappableClass()
class AllNewsState extends BaseState with AllNewsStateMappable {
  final List<News> news;
  const AllNewsState({super.message, super.statusState, this.news = const []});
}
