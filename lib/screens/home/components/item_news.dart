import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/news.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';
import '../../detail_news/detail_news_screen.dart';

class ItemNews extends StatelessWidget {
  final News news;
  const ItemNews({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final News(:title, :image) = news;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: () => AppRoute.to(DetailNewsScreen(news: news)),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: 300,
              height: 200,
              errorWidget: (context, url, error) => Container(
                color: War9aColors.primaryColor,
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  title,
                  style: War9aTextstyle.normal.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
