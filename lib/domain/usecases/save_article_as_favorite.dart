import '../entities/entities.dart';

abstract class SaveArticleAsFavorite {
  Future<int> call(ArticleEntity article);
}
