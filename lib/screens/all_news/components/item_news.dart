import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../components/export_components.dart';
import '../../../models/news.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';

class ItemNews extends StatelessWidget {
  final News news;
  final int index;
  final void Function()? onClick;
  const ItemNews(
      {super.key, required this.news, required this.index, this.onClick});

  @override
  Widget build(BuildContext context) {
    final News(:title, :createdAt, :image) = news;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: context.mediaSize.width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: index.isEven
                ? War9aColors.primaryColor.withOpacity(0.22)
                : War9aColors.greyE2.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: War9aColors.greyF2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.no_photography_rounded),
                    ),
                  )),
            )),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: War9aTextstyle.blackW500Font13,
                    ),
                    const SpacerWidget(4),
                    Text(
                      createdAt?.formatDefault ?? '-',
                      style: War9aTextstyle.blackW400Font10,
                    )
                  ],
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Button(
                'Baca',
                onPressed: onClick,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
