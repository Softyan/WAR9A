import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';
import '../../../data/base_state.dart';
import '../../../models/news.dart';
import '../../../repository/news_repository.dart';

part 'detail_news_state.dart';
part 'detail_news_cubit.mapper.dart';

@injectable
class DetailNewsCubit extends Cubit<DetailNewsState> {
  DetailNewsCubit(this._newsRepository) : super(const DetailNewsState());

  final NewsRepository _newsRepository;

  void deleteNews(News news) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _newsRepository.deleteNews(news.id);

    final newState = result.when(
        result: (String data) => state.copyWith(
              statusState: StatusState.success,
              message: data,
            ),
        error: (String message) =>
            state.copyWith(statusState: StatusState.failure, message: message));

    emit(newState);
  }
}
