import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/notification.dart';
import '../../../repository/notification_repository.dart';

part 'notification_state.dart';
part 'notification_cubit.mapper.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;
  NotificationCubit(this._notificationRepository)
      : super(const NotificationState());

  void init() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _notificationRepository.getListNotification();

    final newState = result.when(
      result: (data) {
        final notReadedNotifs =
            data.where((notification) => notification.isRead == false).toList();

        return state.copyWith(
            statusState: StatusState.idle,
            notifications: data,
            shownReadAll: notReadedNotifs.isNotEmpty);
      },
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }

  void readAllNotification() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _notificationRepository.readAllNotification();

    final newState = result.when(
      result: (data) {
        final notReadedNotifs =
            data.where((notification) => notification.isRead == false).toList();

        return state.copyWith(
            statusState: StatusState.idle,
            notifications: data,
            shownReadAll: notReadedNotifs.isNotEmpty);
      },
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }

  void readNotification(String notificationId) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result =
        await _notificationRepository.readNotification(notificationId);

    final newState = result.when(
        result: (void data) => state.copyWith(statusState: StatusState.idle),
        error: (String message) =>
            state.copyWith(message: message, statusState: StatusState.failure));

    emit(newState);
  }
}
