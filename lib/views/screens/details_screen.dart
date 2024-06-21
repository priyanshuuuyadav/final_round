import 'package:final_assignment_app/controllers/news_controller.dart';
import 'package:final_assignment_app/models/news_model.dart';
import 'package:final_assignment_app/views/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/time_converter.dart';
import '../utils/colors/colors.dart';

class NewsDetailScreen extends StatelessWidget {
  final ArticleModel article;
  final NewsController controller;

  NewsDetailScreen({required this.article, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.author ?? 'News detail',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              article.source?.name ?? 'News source',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
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
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async => await launch(article.url ?? ""),
              child: RichText(
                text: TextSpan(
                  text: article.title ?? 'No Title',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async => await launch(article.url ?? ""),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              article.source?.name ?? "No Source",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            if (article.author != null)
              Text(
                "Author: ${article.author}",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: primaryColor)),
              child: Text(
                article.publishedAt != null
                    ? "Published at : ${formatDate(article.publishedAt.toString() ?? "")} | ${formatTime(article.publishedAt.toString() ?? "")}"
                    : "No Date",
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              article.content ?? "No Content",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        bool isSaved = controller.isArticleSaved(article.url ?? '');
        return IconButton(
          onPressed: () async {
            await controller.saveAndRemoveSaveArticle(
                article.url ?? '', article);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(isSaved
                      ? 'Article removed from favourite!'
                      : 'Article added to favourite!')),
            );
          },
          icon: Icon(
            isSaved
                ? CupertinoIcons.bookmark_fill
                : CupertinoIcons.bookmark,
            color: primaryColor,
            size: 35,
          ),
        );
      }),
    );
  }
}
