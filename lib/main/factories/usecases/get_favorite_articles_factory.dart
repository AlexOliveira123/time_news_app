import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';

GetFavoriteArticles makeLocalGetFavoriteArticles() {
  return LocalGetFavoriteArticles(cache: makeSqliteDatabaseAdapter());
}
