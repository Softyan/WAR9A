import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/enums/role.dart';
import '../../../models/news.dart';
import '../../../repository/news_repository.dart';
import '../../../repository/shared_preference_repository.dart';

part 'all_news_state.dart';
part 'all_news_cubit.mapper.dart';

@injectable
class AllNewsCubit extends Cubit<AllNewsState> {
  final NewsRepository _newsRepository;
  final SharedPreferenceRepository _preferenceRepository;
  AllNewsCubit(this._newsRepository, this._preferenceRepository)
      : super(const AllNewsState());

  void getAllNews({String? search}) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final response = await _newsRepository.getNews(search: search);
    final role = _preferenceRepository.getRole();

    final newState = response.when(
        result: (List<News> data) => state.copyWith(
            statusState: StatusState.idle, news: data, role: role),
        error: (String message) =>
            state.copyWith(statusState: StatusState.failure, message: message));

    emit(newState);
  }
}
