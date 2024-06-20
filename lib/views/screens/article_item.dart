import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_assignment_app/controllers/news_controller.dart';
import 'package:final_assignment_app/controllers/time_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/news_model.dart';
import 'details_screen.dart';

class ArticleItemView extends StatelessWidget {
  final ArticleModel article;
  final NewsController controller = Get.find<NewsController>();

  ArticleItemView({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => NewsDetailScreen(article: article));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(6)),
        margin: EdgeInsets.only(bottom: 8, left: 10, right: 10),
        child: Padding(
          padding: EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              article.urlToImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: article.urlToImage!,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[200],
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
                  PhysicalModel(
                      borderRadius: BorderRadius.circular(4),
                      shape: BoxShape.rectangle,
                      color: Colors.white70,
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 5, right: 5),
                        child: Text(
                          article.publishedAt != null
                              ? "Published at : ${formatDate(article.publishedAt.toString()??"")} | ${formatTime(article.publishedAt.toString()??"")}"
                              : "No Date",
                          style: TextStyle(fontSize: 14),
                        ),
                      )),
                  Obx(() {
                    bool isSaved = controller.isArticleSaved(article.url ?? '');
                    return IconButton(
                      onPressed: () async {
                        await controller.saveAndRemoveSaveArticle(article.url ?? '');
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
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
