import 'package:time_news_app/domain/helpers/helpers.dart';

import '../../domain/entities/entities.dart';
import '../../core/extensions/extensions.dart';

class RemoteArticleModel {
  final String author;
  final String title;
  final String description;
  final String content;
  final String sourceName;
  final String url;
  final String urlToImage;
  final String publishedAt;

  RemoteArticleModel({
    required this.author,
    required this.title,
    required this.description,
    required this.content,
    required this.sourceName,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory RemoteArticleModel.fromJson(Map json) {
    try {
      return RemoteArticleModel(
        author: json['author'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        content: json['content'] ?? '',
        sourceName: json['source']['name'] ?? '',
        url: json['url'] ?? '',
        urlToImage: json['urlToImage'] ?? '',
        publishedAt: json['publishedAt'] ?? '',
      );
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      author: author,
      title: title.normalizeQuotes(),
      description: description.normalizeQuotes(),
      content: content.normalizeQuotes(),
      sourceName: sourceName,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
    );
  }
}
