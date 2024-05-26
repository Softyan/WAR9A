import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../models/news.dart';
import '../../../res/export_res.dart';
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
                      onPressed: () {},
                      child: Text(
                        'Lihat Semua',
                        style: War9aTextstyle.normal.copyWith(color: Colors.blue),
                      )))
            ],
          ),
        ),
        CarouselSlider.builder(
          itemCount: news.length,
          itemBuilder: (context, index, realIndex) =>
              ItemNews(news: news[index]),
          options: CarouselOptions(
            aspectRatio: 2.0,
          ),
        )
      ],
    );
  }
}
