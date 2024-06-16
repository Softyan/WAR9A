part of 'add_news_cubit.dart';

@MappableClass()
class AddNewsState extends BaseState with AddNewsStateMappable {
  final News? news;
  final String pathImage;
  const AddNewsState({super.message, super.statusState, this.news, this.pathImage = ''});
}
