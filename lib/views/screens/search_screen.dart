import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/news_controller.dart';
import '../../models/news_model.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsController newsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search News'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: newsController.queryController.value,
                    onChanged: (value) => newsController.searchArticles(value),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Search articles",
                      fillColor: Color(0xffefefef),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                _buildCategoryDropdown(),
              ],
            ),
            SizedBox(height: 16.0),
            Obx((){
              if(!newsController.searchStats.value){
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: newsController.filteredArticles.length,
                    itemBuilder: (context, index) {
                      ArticleModel article = newsController.filteredArticles[index];
                      return ListTile(
                        title: Text(article.title ?? 'No Title', style: TextStyle(overflow: TextOverflow.ellipsis),),
                        subtitle: Text(article.publishedAt != null
                            ? article.publishedAt!.toString()
                            : 'No Date'),
                        onTap: () {
                          Get.to(NewsDetailScreen(
                            article: article,
                          ));
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: article.urlToImage??"",
                            placeholder: (context, url) =>
                                Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator(strokeWidth: 2,)),),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            width: 40,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }else{
                return  Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: newsController.articlesByQuery.length,
                    itemBuilder: (context, index) {
                      ArticleModel article = newsController.articlesByQuery[index];
                      return ListTile(
                        title: Text(article.title ?? 'No Title', style: TextStyle(overflow: TextOverflow.ellipsis),),
                        subtitle: Text(article.publishedAt != null
                            ? article.publishedAt!.toString()
                            : 'No Date'),
                        onTap: () {
                          Get.to(NewsDetailScreen(
                            article: article,
                          ));
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: article.urlToImage??"",
                            placeholder: (context, url) =>
                                Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator(strokeWidth: 2,)),),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            width: 40,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },)
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(
      () => Container(
        constraints: BoxConstraints(minWidth: double.minPositive),
        child: DropdownButton<String>(
          padding: EdgeInsets.zero,
          iconSize: 25,
          underline: null,
          elevation: 0,
          isExpanded: false,
          alignment: Alignment.topRight,
          borderRadius: BorderRadius.circular(10),
          value: newsController.selectedCategory.value,

          onChanged: (String? newValue) {
            if (newValue != null) {
              newsController.fetchArticlesWithApiByCategory(newValue);
            }
          },
          items: <String>[
            'all',
            'business',
            'entertainment',
            'general',
            'health',
            'science',
            'sports',
            'technology'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}