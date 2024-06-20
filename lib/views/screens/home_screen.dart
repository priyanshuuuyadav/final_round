import 'package:final_assignment_app/controllers/news_controller.dart';
import 'package:final_assignment_app/views/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../models/news_model.dart';
import 'Favorite_screen.dart';
import 'article_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<NewsModel?> newsModel;

  NewsController newsController = Get.put(NewsController());

  @override
  void initState() {
    super.initState();
    newsModel = newsController.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          Obx(
            () =>  Badge(
              label: Text(newsController.savedArticlesList.length.toString()),
              child: IconButton(
                  onPressed: () {
                    Get.to(FavoriteScreen());
                  },
                  icon: Icon(Icons.bookmark)),
            ),
          ),
          IconButton(
              onPressed: () {
                Get.to(SearchScreen());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: FutureBuilder<NewsModel?>(
        future: newsModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.error}"));
          } else if (!snapshot.hasData ||
              snapshot.data?.articles == null ||
              snapshot.data!.articles!.isEmpty) {
            return const Center(child: Text("No news found"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.articles!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data!.articles![index];
                return ArticleItemView(
                  article: article,
                );
              },
            );
          }
        },
      ),
    );
  }
}
