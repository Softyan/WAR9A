import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../components/export_components.dart';
import '../../../res/export_res.dart';

class ContentFilter extends StatefulWidget {
  final Key formKey;
  final int? selectedRt;
  final String? selectedDomisili;
  final void Function(int? rt)? onChangedRt;
  final void Function(String? domisili)? onChangedDomisili;
  final void Function()? onFilter;
  final void Function()? onReset;
  const ContentFilter(
      {super.key,
      required this.formKey,
      this.onFilter,
      this.selectedRt,
      this.selectedDomisili,
      this.onChangedRt,
      this.onChangedDomisili,
      this.onReset});

  @override
  State<ContentFilter> createState() => _ContentFilterState();
}

class _ContentFilterState extends State<ContentFilter> {
  int? initRt;
  String? initDomisili;
  bool? isDomisili;

  @override
  void initState() {
    super.initState();
    initRt = widget.selectedRt;
    initDomisili = widget.selectedDomisili;
    isDomisili = initDomisili == null ? null : initDomisili == "menetap";
  }

  @override
  Widget build(BuildContext context) {
    const space = 16.0;
    return FormBuilder(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  Icons.drag_handle_rounded,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
            const SpacerWidget(space),
            Text(
              "Filter berdasarkan RT",
              style: War9aTextstyle.primaryW600Font10
                  .copyWith(color: Colors.grey, fontSize: 16),
            ),
            const SpacerWidget(space),
            FormBuilderField<int>(
              name: 'rt',
              initialValue: initRt,
              builder: (FormFieldState<int> field) => Wrap(
                spacing: 8,
                children: List.generate(4, (i) => i + 1)
                    .map((rt) => GestureDetector(
                          onTap: () {
                            final selectedRt = initRt == rt ? null : rt;
                            field.didChange(selectedRt);
                            widget.onChangedRt?.call(selectedRt);
                            setState(() {
                              initRt = selectedRt;
                            });
                          },
                          child: Container(
                            width: 70,
                            height: 40,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: initRt == rt
                                    ? War9aColors.primaryColor
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: War9aColors.primaryColor)),
                            child: Text(
                              "0$rt",
                              style: War9aTextstyle.normal.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: initRt == rt ? Colors.white : null),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SpacerWidget(space),
            Text(
              "Filter berdasarkan status domisili",
              style: War9aTextstyle.primaryW600Font10
                  .copyWith(color: Colors.grey, fontSize: 16),
            ),
            const SpacerWidget(space),
            FormBuilderField<bool>(
              name: 'isStay',
              initialValue: isDomisili,
              builder: (FormFieldState<bool> field) => Wrap(
                spacing: 8,
                children: ["Menetap", "Sementara"]
                    .map((domisili) => GestureDetector(
                        onTap: () {
                          final newDomisili = domisili.toLowerCase();
                          final selectedDomisili =
                              newDomisili == initDomisili ? null : newDomisili;
                          final resultDomisili = newDomisili == initDomisili
                              ? null
                              : newDomisili == "menetap";
                          field.didChange(resultDomisili);
                          widget.onChangedDomisili?.call(selectedDomisili);
                          setState(() {
                            initDomisili = selectedDomisili?.toLowerCase();
                          });
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: initDomisili?.toLowerCase() ==
                                      domisili.toLowerCase()
                                  ? War9aColors.primaryColor
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: War9aColors.primaryColor)),
                          child: Text(
                            domisili,
                            style: War9aTextstyle.normal.copyWith(
                                fontWeight: FontWeight.w500,
                                color: initDomisili?.toLowerCase() ==
                                        domisili.toLowerCase()
                                    ? Colors.white
                                    : null),
                          ),
                        )))
                    .toList(),
              ),
            ),
            const SpacerWidget(space),
            Row(
              children: [
                Expanded(
                  child: Button(
                    "Reset",
                    onPressed: widget.onReset,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    textStyle: TextStyle(color: War9aColors.primaryColor),
                    borderStyle: BorderSide(color: War9aColors.primaryColor),
                  ),
                ),
                const SpacerWidget(
                  8,
                  isHorizontal: true,
                ),
                Expanded(
                  child: Button(
                    "Cari",
                    onPressed: widget.onFilter,
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
