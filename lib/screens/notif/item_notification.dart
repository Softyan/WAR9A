import 'package:flutter/material.dart';

import '../../components/export_components.dart';
import '../../models/notification.dart' as model;
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';

typedef OnClick = void Function();

class ItemNotification extends StatelessWidget {
  final model.Notification notification;
  final OnClick? onClick;
  const ItemNotification({super.key, required this.notification, this.onClick});

  @override
  Widget build(BuildContext context) {
    final model.Notification(:message, :createdAt) = notification;
    return Container(
      width: context.mediaSize.width,
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(6),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: War9aColors.greyF2,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: War9aTextstyle.normal,
                  ),
                  const SpacerWidget(8),
                  Text(
                    createdAt?.formatWithoutTime ?? '-',
                    style: War9aTextstyle.normal.copyWith(fontSize: 11),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
