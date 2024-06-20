import 'package:final_assignment_app/models/news_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final ArticleModel article;

  NewsDetailScreen({required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.article.author ?? 'News detail',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.article.source?.name ?? 'News source',
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
            widget.article.urlToImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                      imageUrl: widget.article.urlToImage!,
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
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async => await launch(widget.article.url ?? ""),
              child: RichText(
                text: TextSpan(
                  text: widget.article.title ?? 'No Title',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        () async => await launch(widget.article.url ?? ""),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.article.source?.name ?? "No Source",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              widget.article.publishedAt != null
                  ? "Published at: ${widget.article.publishedAt!.toLocal().toIso8601String()}"
                  : "No Date",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            if (widget.article.author != null)
              Text(
                "Author: ${widget.article.author}",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            SizedBox(height: 16.0),
            Text(
              widget.article.content ?? "No Content",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
