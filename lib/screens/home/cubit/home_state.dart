part of 'home_cubit.dart';

@MappableClass()
class HomeState extends BaseState with HomeStateMappable {
  final User? user;
  final List<News> news;
  final List<Widget> contents;
  const HomeState(
      {super.message,
      super.statusState,
      this.user,
      this.news = const [],
      this.contents = const []});
}
