import '../../../presentation/presentation.dart';
import '../../../ui/ui.dart';
import '../usecases/usecases.dart';

SearchPresenter makeCubitSearchPresenter() {
  return CubitSearchPresenter(
    findArticleByKeyword: makeRemoteFindArticleByKeyword(),
    getFavoriteArticles: makeLocalGetFavoriteArticles(),
    removeArticleFromFavorites: makeLocalRemoveArticleFromFavorites(),
    saveArticleAsFavorite: makeLocalSaveArticleAsFavorite(),
  );
}
