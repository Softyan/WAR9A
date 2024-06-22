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
    final model.Notification(:message, :createdAt, :isRead) = notification;
    return Container(
      width: context.mediaSize.width,
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: isRead == false ? onClick : null,
          borderRadius: BorderRadius.circular(6),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: War9aColors.greyC4.withOpacity(0.15)),
              color: isRead
                  ? Colors.white.withOpacity(0.20)
                  : War9aColors.greyC4.withOpacity(0.15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 6.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !isRead
                              ? War9aColors.primaryColor
                              : Colors.white.withOpacity(0.20)),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
