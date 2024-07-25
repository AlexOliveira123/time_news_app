import 'entities.dart';

class FavoriteArticleEntity extends ArticleEntity {
  final int id;

  const FavoriteArticleEntity({
    required this.id,
    required super.author,
    required super.title,
    required super.description,
    required super.content,
    required super.sourceName,
    required super.url,
    required super.urlToImage,
    required super.publishedAt,
  });
}
