import '../domain/entities/entities.dart';

abstract class SearchPresenter {
  abstract String keyword;
  void onKeywordChanged(String value);
  Map<String, List<ArticleEntity>> get groupedNews;
  Future<void> getNews();
  Map<String, List<FavoriteArticleEntity>> get groupedFavoriteNews;
  Future<void> getFavoriteNews();
  Future<void> addFavorite(ArticleEntity article);
  Future<void> removeFavorite(FavoriteArticleEntity favoriteArticle);
  int get currentTab;
  void onTabChanged(int tabIndex);
  void dispose();
}
