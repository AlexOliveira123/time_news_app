import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String author;
  final String title;
  final String description;
  final String content;
  final String sourceName;
  final String url;
  final String urlToImage;
  final String publishedAt;

  const ArticleEntity({
    required this.author,
    required this.title,
    required this.description,
    required this.content,
    required this.sourceName,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  @override
  List<Object> get props {
    return [
      author,
      title,
      description,
      content,
      sourceName,
      url,
      urlToImage,
      publishedAt,
    ];
  }
}
