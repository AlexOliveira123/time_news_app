import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';

class LocalArticleModel {
  final int? id;
  final String author;
  final String title;
  final String description;
  final String content;
  final String sourceName;
  final String url;
  final String urlToImage;
  final String publishedAt;

  LocalArticleModel({
    this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.content,
    required this.sourceName,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory LocalArticleModel.fromEntity(ArticleEntity article) {
    return LocalArticleModel(
      author: article.author,
      title: article.title,
      description: article.description,
      content: article.content,
      sourceName: article.sourceName,
      url: article.url,
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
    );
  }

  factory LocalArticleModel.fromJson(Map json) {
    try {
      return LocalArticleModel(
        id: json['id'],
        author: json['author'],
        title: json['title'],
        description: json['description'],
        content: json['content'],
        sourceName: json['sourceName'],
        url: json['url'],
        urlToImage: json['urlToImage'],
        publishedAt: json['publishedAt'],
      );
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  String toDataString() {
    return '(author, title, description, content, sourceName, url, urlToImage, publishedAt) VALUES ("$author", "$title", "$description", "$content", "$sourceName", "$url", "$urlToImage", "$publishedAt")';
  }

  FavoriteArticleEntity toEntity() {
    return FavoriteArticleEntity(
      id: id!,
      author: author,
      title: title,
      description: description,
      content: content,
      sourceName: sourceName,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
    );
  }
}
