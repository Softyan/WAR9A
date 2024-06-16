import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../components/export_components.dart';
import '../../models/news.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';

class DetailNewsScreen extends StatelessWidget {
  final News news;
  const DetailNewsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        "Detail Berita",
        backgroundColor: context.backgroundColor,
      ),
      body: ListWidget(
        _contents,
        isSeparated: true,
        itemBuilder: (BuildContext context, Widget item, int index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: item,
        ),
        separatorBuilder: (context, item, index) => const SpacerWidget(8),
      ),
    );
  }

  List<Widget> get _contents => [
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: news.title,
            style: War9aTextstyle.blackW600Font16.copyWith(fontSize: 20),
          ),
          const TextSpan(text: '\n'),
          TextSpan(
              text: news.createdAt?.formattedDate() ?? "-",
              style: War9aTextstyle.normal),
        ])),
        SizedBox(
          height: 200,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: news.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: War9aColors.greyF2,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Text("Can't loaded Image")),
                ),
              )),
        ),
        ListWidget<String>(
          news.contents ?? [],
          scrollPhysics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          isSeparated: true,
          separatorBuilder: (context, item, index) => const SpacerWidget(8),
          itemBuilder: (BuildContext context, String item, int index) => Text(
            item,
            textAlign: TextAlign.justify,
            style: War9aTextstyle.normal,
          ),
        )
      ];
}
