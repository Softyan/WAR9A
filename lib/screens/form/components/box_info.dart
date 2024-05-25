import 'package:flutter/material.dart';

import '../../../res/export_res.dart';
import '../../../utils/app_context.dart';

class BoxInfo extends StatelessWidget {
  const BoxInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.mediaSize.width,
      decoration: BoxDecoration(
        color: War9aColors.blueInfo,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                text: "Lengkapi data diri untuk mempercepat verifikasi\n",
                style: War9aTextstyle.normal.copyWith(
                    color: War9aColors.blueTextInfo,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                children: [
                  TextSpan(
                    text:
                        "Kami melindungi informasi dan penggunaan data diri yang telah anda kirimkan untuk kenyaman pengguna.",
                    style: War9aTextstyle.normal.copyWith(
                        color: War9aColors.blueTextInfo, fontSize: 12),
                  )
                ])),
      ),
    );
  }
}
