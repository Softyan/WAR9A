import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../res/export_res.dart';

class PickImageWidget extends StatelessWidget {
  final String imageFile;
  final void Function()? pickImage;
  const PickImageWidget(
      {super.key, required this.pickImage, this.imageFile = ''});

  @override
  Widget build(BuildContext context) {
    if (imageFile.isNotEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 0.5)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: pickImage,
              child: Image.file(
                File(imageFile),
                fit: BoxFit.cover,
              ),
            )),
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
          onTap: pickImage,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.image,
                  color: War9aColors.primaryColor,
                  size: 56,
                ),
                Text(
                  "Photo",
                  style: War9aTextstyle.normal.copyWith(fontSize: 10),
                )
              ],
            ),
          ),
        ));
  }
}
