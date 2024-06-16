import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/news.dart';
import '../../../repository/news_repository.dart';

part 'add_news_state.dart';
part 'add_news_cubit.mapper.dart';

@injectable
class AddNewsCubit extends Cubit<AddNewsState> {
  final NewsRepository _newsRepository;
  AddNewsCubit(this._newsRepository) : super(const AddNewsState());

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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      emit(state.copyWith(
          message: "Canceled pick image", statusState: StatusState.failure));
      return;
    }
    final String? path = result.files.first.path;
    if (path == null || path.isEmpty) {
      emit(state.copyWith(
          message: "Path image is empty", statusState: StatusState.failure));
      return;
    }

    final file = File(path);
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb > 2) {
      emit(state.copyWith(
          statusState: StatusState.failure,
          message: "Image is bigger than 2 MB"));
      return;
    }

    emit(state.copyWith(pathImage: path));
  }
}
