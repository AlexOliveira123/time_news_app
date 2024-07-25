import 'package:flutter/material.dart';

import '../core/helpers/helpers.dart';
import '../domain/entities/entities.dart';

class DetailPage extends StatelessWidget {
  final ArticleEntity article;

  const DetailPage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(DateFormatter.format(article.publishedAt)),
              const SizedBox(height: 16),
              Image.network(article.urlToImage),
              const SizedBox(height: 24),
              Text(article.description),
              const SizedBox(height: 16),
              Text(article.content),
              const SizedBox(height: 24),
              Text(article.url),
            ],
          ),
        ),
      ),
    );
  }
}
