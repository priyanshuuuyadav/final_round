import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_assignment_app/controllers/news_controller.dart';
import 'package:final_assignment_app/controllers/time_converter.dart';
import 'package:final_assignment_app/views/utils/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/news_model.dart';
import '../utils/constant.dart';
import 'details_screen.dart';

class ArticleItemView extends StatelessWidget {
  final ArticleModel article;
  final NewsController controller;

  ArticleItemView({required this.article, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => NewsDetailScreen(article: article));
      },
      child: Container(
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "${article.url}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? defaultImage,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              article.title ?? "No Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              article.source?.name ?? "No Source",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primaryColor)),
                  child: Text(
                    article.publishedAt != null
                        ? "Published at : ${formatDate(article.publishedAt.toString() ?? "")} | ${formatTime(article.publishedAt.toString() ?? "")}"
                        : "No Date",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Obx(() {
                  bool isSaved = controller.isArticleSaved(article.url ?? '');
                  return IconButton(
                    onPressed: () async {
                      await controller.saveAndRemoveSaveArticle(
                          article.url ?? '', article);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(isSaved
                                ? 'Article removed!'
                                : 'Article saved!')),
                      );
                    },
                    icon: Icon(
                      isSaved
                          ? CupertinoIcons.bookmark_fill
                          : CupertinoIcons.bookmark,
                      color: primaryColor,
                      size: 26,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
