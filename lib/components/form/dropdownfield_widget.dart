import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef OnItemsBuilder<T> = DropdownMenuItem<T> Function(T);

class DropdownfieldWidget<T> extends FormBuilderDropdown<T> {
  final List<T> list;
  final String keyName;
  final double? radius;
  final String? label;
  final OnItemsBuilder<T>? onItemsBuilder;

  DropdownfieldWidget(this.keyName, this.list,
      {super.key,
      this.radius,
      this.label,
      this.onItemsBuilder,
      super.validator,
      super.initialValue})
      : super(
            name: keyName,
            items: list.map((item) {
              if (onItemsBuilder != null) return onItemsBuilder(item);
              return DropdownMenuItem<T>(
                  value: item, child: Text(item.toString()));
            }).toList(),
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius ?? 16)),
                borderSide: const BorderSide(width: 2),
              ),
            ));
}
