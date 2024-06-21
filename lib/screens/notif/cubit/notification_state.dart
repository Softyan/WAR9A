part of 'notification_cubit.dart';

@MappableClass()
class NotificationState extends BaseState with NotificationStateMappable {
  final List<Notification> notifications;
  final bool shownReadAll;
  const NotificationState({
    super.message,
    super.statusState,
    this.notifications = const [],
    this.shownReadAll = false
  });
}
