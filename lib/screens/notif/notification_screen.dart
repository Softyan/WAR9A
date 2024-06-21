import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/notification.dart' as model;
import '../../res/export_res.dart';
import '../../utils/app_context.dart';
import 'cubit/notification_cubit.dart';
import 'item_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = getIt<NotificationCubit>();
    _notificationCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Notifikasi",
        showBackButton: false,
        backgroundColor: context.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer<NotificationCubit, NotificationState>(
          bloc: _notificationCubit,
          listener: (context, state) {
            if (state.isError) {
              context.snackbar.showSnackBar(
                  SnackbarWidget(state.message, state: SnackbarState.error));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const LoadingWidget();
            }

            if (state.notifications.isEmpty) {
              return EmptyDataWidget(
                onClick: _notificationCubit.init,
              );
            }

            return Column(
              children: [
                state.shownReadAll
                    ? Container(
                        width: context.mediaSize.width,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: _notificationCubit.readAllNotification,
                          child: Text("Mark all as read",
                              style: War9aTextstyle.normal.copyWith(
                                  color: War9aColors.blueClick,
                                  fontSize: 11,
                                  decoration: TextDecoration.underline)),
                        ),
                      )
                    : Container(),
                Expanded(
                    child: RefreshIndicator.adaptive(
                  onRefresh: () async {
                    _notificationCubit.init();
                    Future.delayed(const Duration(seconds: 2));
                  },
                  child: ListWidget<model.Notification>(
                    state.notifications,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (BuildContext context, model.Notification item,
                            int index) =>
                        ItemNotification(
                      notification: item,
                      onClick: () {
                        _notificationCubit.readNotification(item.id);
                      },
                    ),
                  ),
                ))
              ],
            );
          },
        ),
      ),
    );
  }
}
