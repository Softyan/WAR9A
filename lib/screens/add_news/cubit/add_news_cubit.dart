import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/news.dart';
import '../../../repository/news_repository.dart';
import '../../../utils/export_utils.dart';

part 'add_news_state.dart';
part 'add_news_cubit.mapper.dart';

@injectable
class AddNewsCubit extends Cubit<AddNewsState> {
  final NewsRepository _newsRepository;
  final GlobalHelpers _globalHelpers;
  AddNewsCubit(this._newsRepository, this._globalHelpers)
      : super(const AddNewsState());

  void addNews(News news) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final response = await _newsRepository.addNews(news);

    final newState = response.when(
        result: (News data) => state.copyWith(
            statusState: StatusState.success,
            message: "News was added",
            pathImage: ""),
        error: (String message) =>
            state.copyWith(statusState: StatusState.failure, message: message));

    emit(newState);
  }

  void pickImage() async {
    emit(state.copyWith(statusState: StatusState.loading));
    final result = await _globalHelpers.pickFile();

    final newState = result.when(
        result: (String data) =>
            state.copyWith(pathImage: data, statusState: StatusState.idle),
        error: (String message) =>
            state.copyWith(statusState: StatusState.failure, message: message));
    emit(newState);
  }
}
