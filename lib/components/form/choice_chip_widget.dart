import 'package:flutter/material.dart';

import '../../res/export_res.dart';

class ChoiceChipWidget extends ChoiceChip {
  final String title;
  final bool isSelected;
  ChoiceChipWidget(this.title, this.isSelected, {super.key, super.onSelected})
      : super(
            label: Text(title),
            selected: isSelected,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: War9aColors.primaryColor)),
            showCheckmark: false,
            selectedColor: War9aColors.primaryColor,
            labelStyle: TextStyle(color: isSelected ? Colors.white : null));
}
