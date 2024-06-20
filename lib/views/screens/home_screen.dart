import 'package:final_assignment_app/controllers/news_controller.dart';
import 'package:final_assignment_app/views/screens/search_screen.dart';
import 'package:final_assignment_app/views/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              color: primaryColor,
              onPressed: () {
                Get.to(SearchScreen());
              },
              icon: Icon(Icons.search)),
          Obx(
            () => Badge(
              offset: Offset(-7, 4),
              label: Text(newsController.shavedArticlesLength.toString()),
              child: IconButton(
                  color: primaryColor,
                  onPressed: () {
                    Get.to(FavoriteScreen());
                  },
                  icon: Icon(Icons.bookmark)),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Hero(tag:"splash",child: Image.asset("assets/icons/news.png",)),
        ),
        leadingWidth: 35,
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
                  controller: newsController,
                );
              },
            );
          }
        },
      ),
    );
  }
}
