
import '../entities/entities.dart';

abstract class GetFavoriteArticles {
  Future<List<FavoriteArticleEntity>> call();
}
