import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_assignment_app/controllers/news_controller.dart';
import 'package:final_assignment_app/views/screens/article_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/time_converter.dart';
import '../../models/news_model.dart';
import 'details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  final NewsController controller = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Articles'),
      ),
      body: Obx(() {
        if (controller.savedArticlesList.isEmpty) {
          return Center(child: Text('No saved articles'));
        } else {
          return ListView.builder(
            itemCount: controller.savedArticlesList.length,
            itemBuilder: (context, index) {
              ArticleModel article = controller.savedArticlesList[index];
              return ArticleItemView(
                article: article,
              );
            },
          );
        }
      }),
    );
  }
}
