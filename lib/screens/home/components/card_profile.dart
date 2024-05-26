import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';

class CardProfile extends StatelessWidget {
  final User user;
  const CardProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: context.mediaSize.width,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.25),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(flex: 2, child: Assets.images.profile.image()),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi,", style: War9aTextstyle.w700_18),
                      Text(user.name, style: War9aTextstyle.w700_18),
                      Text(user.nik, style: War9aTextstyle.w700_18),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
