import '../../core/config/config.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/cache/cache.dart';

class LocalRemoveArticleFromFavorites implements RemoveArticleFromFavorites {
  final DeleteCache cache;

  LocalRemoveArticleFromFavorites({required this.cache});

  @override
  Future<void> call(int id) async {
    try {
      final key = '${ENV.favoriteTableName} WHERE id = $id';
      await cache.delete(key);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
