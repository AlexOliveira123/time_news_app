import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';

SaveArticleAsFavorite makeLocalSaveArticleAsFavorite() {
  return LocalSaveArticleAsFavorite(cache: makeSqliteDatabaseAdapter());
}
