import 'package:flutter/material.dart';

import '../../../components/export_components.dart';
import '../../../models/user.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';
import '../../profile/profile_screen.dart';

class ItemDataWarga extends StatelessWidget {
  final User user;
  final int index;
  const ItemDataWarga({super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final User(:name, :rt, :birthDate) = user;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => AppRoute.to(ProfileScreen(
          user: user,
        )),
        child: Container(
          width: context.mediaSize.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: index.isEven
                  ? War9aColors.primaryColor.withOpacity(0.22)
                  : War9aColors.greyE2.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama : $name",
                style: War9aTextstyle.normal,
              ),
              Text(
                "Rukun Tetangga : $rt",
                style: War9aTextstyle.normal,
              ),
              const SpacerWidget(8),
              Text(
                birthDate?.formattedDate(pattern: 'dd MMMM yyyy') ?? '-',
                style: War9aTextstyle.normal
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
