import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';

RemoveArticleFromFavorites makeLocalRemoveArticleFromFavorites() {
  return LocalRemoveArticleFromFavorites(cache: makeSqliteDatabaseAdapter());
}
