import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../res/export_res.dart';

class RtPickerWidget extends StatefulWidget {
  final String keyName;
  final int? totalRt;
  final int? initialValue;
  const RtPickerWidget(
    this.keyName, {
    super.key,
    this.totalRt,
    this.initialValue,
  });

  @override
  State<RtPickerWidget> createState() => _RtPickerWidgetState();
}

class _RtPickerWidgetState extends State<RtPickerWidget> {
  late int selectedRt;
  @override
  void initState() {
    super.initState();
    final initialValue = widget.initialValue;
    selectedRt = (initialValue != null && initialValue != 0) ? initialValue : 1;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<int>(
      name: widget.keyName,
      initialValue: selectedRt,
      builder: (FormFieldState<int> field) => InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          errorText: field.errorText,
        ),
        child: Wrap(
          spacing: 16.0,
          alignment: WrapAlignment.spaceBetween,
          children: List.generate(widget.totalRt ?? 4, (i) => i + 1)
              .map((rt) => GestureDetector(
                    onTap: () => setState(() {
                      selectedRt = rt;
                      field.didChange(rt);
                    }),
                    child: Container(
                      width: 70,
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: selectedRt == rt
                              ? War9aColors.primaryColor
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: War9aColors.primaryColor)),
                      child: Text(
                        "0$rt",
                        style: War9aTextstyle.normal.copyWith(
                            fontWeight: FontWeight.w500,
                            color: selectedRt == rt ? Colors.white : null),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
