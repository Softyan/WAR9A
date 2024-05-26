import 'package:flutter/material.dart';

import '../../../models/news.dart';
import '../../../res/export_res.dart';

class ItemNews extends StatelessWidget {
  final News news;
  const ItemNews({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final News(:title) = news;
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Stack(
            children: <Widget>[
              Container(
                color: War9aColors.primaryColor,
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
          )),
    );
  }
}
