import 'package:flutter/material.dart';

import '../../res/export_res.dart';
import '../../utils/export_utils.dart';

class AddButton extends StatelessWidget {
  final void Function()? onClick;
  const AddButton({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: War9aColors.primary),
      child: GestureDetector(
        onTap: onClick,
        child: Icon(
          Icons.add,
          color: context.backgroundColor,
        ),
      ),
    );
  }
}
