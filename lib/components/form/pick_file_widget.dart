import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../res/export_res.dart';
import '../../utils/export_utils.dart';

class PickFileWidget extends StatelessWidget {
  final String keyName;
  final List<String> filePaths;
  final void Function()? pickFile;
  const PickFileWidget(
    this.keyName, {
    super.key,
    required this.filePaths,
    this.pickFile,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: keyName,
      initialValue: filePaths.isNotEmpty ? filePaths.first : null,
      validator: FormBuilderValidators.required(),
      builder: (FormFieldState<String> field) => InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          errorText: field.errorText,
        ),
        child: Builder(builder: (context) {
          if (filePaths.isNotEmpty) {
            final ttd = filePaths.first;
            return Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 0.5)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: pickFile,
                    child: ttd.isUrl()
                        ? Image.network(
                            ttd,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(ttd),
                            fit: BoxFit.cover,
                          ),
                  )

                  /// Turn on this to continue multiple picked files
                  // child: filePaths.length == 1 ? _previewImage : _previewImages,
                  ),
            );
          }

          return DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              color: War9aColors.primaryColor,
              padding: EdgeInsets.zero,
              dashPattern: const [10, 5],
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: pickFile,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_rounded,
                        color: War9aColors.primaryColor,
                        size: 56,
                      ),
                      Text(
                        "Select Photo",
                        style: War9aTextstyle.normal.copyWith(fontSize: 10),
                      )
                    ],
                  ),
                ),
              ));
        }),
      ),
    );
  }

  /// Turn on this to continue multiple picked files
  // Widget get _previewImage => InkWell(
  //       onTap: pickFile,
  //       child: Image.file(
  //         File(filePaths[0]),
  //         fit: BoxFit.cover,
  //       ),
  //     );

  // Widget get _previewImages => ListWidget(
  //       filePaths,
  //       isHorizontal: true,
  //       itemBuilder: (BuildContext context, String item, int index) =>
  //           Container(),
  //     );
}
