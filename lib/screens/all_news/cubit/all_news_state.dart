part of 'all_news_cubit.dart';

@MappableClass()
class AllNewsState extends BaseState with AllNewsStateMappable {
  final List<News> news;
  final Role role;
  const AllNewsState(
      {super.message,
      super.statusState,
      this.news = const [],
      this.role = Role.warga});
}
