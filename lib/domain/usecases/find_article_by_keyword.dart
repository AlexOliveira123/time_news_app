import '../entities/entities.dart';

abstract class FindArticleByKeyword {
  Future<List<ArticleEntity>> call(String keyword);
}
