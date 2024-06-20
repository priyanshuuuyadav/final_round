import 'package:final_assignment_app/controllers/sqflite_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news_model.dart';

class NewsController extends GetxController {
  RxList<ArticleModel> articlesByQuery = <ArticleModel>[].obs;
  RxList<ArticleModel> filteredArticles = <ArticleModel>[].obs;
  var savedArticles = <String>[].obs;
  var savedArticlesList = <ArticleModel>[].obs;
  Rx<TextEditingController> queryController = TextEditingController().obs;

  RxList<ArticleModel> allArticlesList = <ArticleModel>[].obs;
  RxList<ArticleModel> allSavedArticlesList = <ArticleModel>[].obs;

  RxString selectedCategory = "all".obs;

  // static String apiKey = "dd358ec576f04ed8ae40571a0a173ac7";
  static String apiKey = "b2e8b1c3327e4c31b93d8a4b9ee1da39";
  static String baseUrl = "https://newsapi.org/v2";
  RxBool searchStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedArticles();
    fetchArticlesWithApiByCategory(selectedCategory.value);
  }

  Future<void> fetchArticlesWithApiByCategory(String category) async {
    selectedCategory.value = category;
    if (selectedCategory.value == "all") {
      var data = await fetchNews();
      if (data != null) {
        filteredArticles.assignAll(data.articles!);
      } else {
        print("Error fetching all news");
      }
    } else {
      try {
        final response = await http.get(Uri.parse(
            "$baseUrl/top-headlines?country=de&category=${selectedCategory.value}&apiKey=$apiKey"));
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          NewsModel newsModel = NewsModel.fromJson(jsonData);
          filteredArticles.assignAll(newsModel.articles!);
        } else {
          throw Exception("Failed to load articles ${response.body}");
        }
      } catch (e) {
        print("Error fetching articles: $e");
      }
    }
  }

  void searchArticles(String query) {
    if (queryController.value.text.isEmpty) {
      searchStats.value = false;
    } else {
      searchStats.value = true;
    }
    articlesByQuery.value = filteredArticles
        .where((article) =>
            article.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<NewsModel?> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/everything?q=keyword&apiKey=$apiKey"),
      );

      if (response.statusCode == 200) {
        var data = NewsModel.fromJson(json.decode(response.body));
        allArticlesList.value.assignAll(data.articles!);
      } else {
        print("Failed to load news ${response.body}");
        return null;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> loadSavedArticles() async {
    final articles = await DatabaseHelper.instance.getSavedArticles();
    savedArticles.assignAll(articles);
  }

  Future<void> saveAndRemoveSaveArticle(String url) async {
    if (savedArticles.contains(url)) {
      await DatabaseHelper.instance.deleteArticle(url);
      savedArticles.remove(url);
    } else {
      await DatabaseHelper.instance.saveArticle(url);
      savedArticles.add(url);
    }
  }

  bool isArticleSaved(String url) {
    return savedArticles.contains(url);
  }

  _getAllArticle(){
    allArticlesList.map((element) {
      DatabaseHelper.
    },)
  }
}