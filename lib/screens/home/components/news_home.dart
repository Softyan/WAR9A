import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../components/export_components.dart';
import '../../../models/news.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';
import '../../all_news/all_news_screen.dart';
import 'item_news.dart';

class NewsHome extends StatelessWidget {
  final List<News> news;
  const NewsHome({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    'Berita',
                    style: War9aTextstyle.title,
                  )),
              Expanded(
                  child: TextButton(
                      onPressed: () => AppRoute.to(const AllNewsScreen()),
                      child: Text(
                        'Lihat Semua',
                        style:
                            War9aTextstyle.normal.copyWith(color: Colors.blue),
                      )))
            ],
          ),
        ),
        const SpacerWidget(16),
        CarouselSlider.builder(
          itemCount: news.length,
          itemBuilder: (context, index, realIndex) =>
              ItemNews(news: news[index]),
          options: CarouselOptions(
              aspectRatio: 2.0, enableInfiniteScroll: news.length >= 2),
        )
      ],
    );
  }
}
