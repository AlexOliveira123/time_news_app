
import '../../core/config/config.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/cache/cache.dart';
import '../models/models.dart';

class LocalSaveArticleAsFavorite implements SaveArticleAsFavorite {
  final SaveCache cache;

  LocalSaveArticleAsFavorite({required this.cache});

  @override
  Future<int> call(ArticleEntity article) async {
    try {
      return await cache.save(
        key: ENV.favoriteTableName,
        value: LocalArticleModel.fromEntity(article).toDataString(),
      );
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
