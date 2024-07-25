import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/entities.dart';
import '../domain/usecases/usecases.dart';
import '../ui/ui.dart';

part 'states.dart';

class CubitSearchPresenter extends Cubit<SearchState> implements SearchPresenter {
  final FindArticleByKeyword findArticleByKeyword;
  final GetFavoriteArticles getFavoriteArticles;
  final RemoveArticleFromFavorites removeArticleFromFavorites;
  final SaveArticleAsFavorite saveArticleAsFavorite;

  CubitSearchPresenter({
    required this.findArticleByKeyword,
    required this.getFavoriteArticles,
    required this.saveArticleAsFavorite,
    required this.removeArticleFromFavorites,
  }) : super(SearchInitialState()) {
    getFavoriteNews();
    _autoRefreshNews();
  }

  final _groupedNews = <String, List<ArticleEntity>>{};
  final _groupedFavoriteNews = <String, List<FavoriteArticleEntity>>{};

  Timer? _timer;
  static const _timeInSecondsToRefresh = 180;

  void _autoRefreshNews() {
    _timer = Timer.periodic(
      const Duration(seconds: _timeInSecondsToRefresh),
      (timer) => getNews(),
    );
  }

  void _fillGroupedNews(List<ArticleEntity> newsList) {
    _groupedNews.clear();
    for (final news in newsList) {
      if (_groupedNews[news.sourceName] == null) _groupedNews[news.sourceName] = [];
      _groupedNews[news.sourceName]?.add(news);
    }
  }

  void _fillGroupedFavoriteNews(List<FavoriteArticleEntity> favoriteNewsList) {
    for (final favoriteNews in favoriteNewsList) {
      if (_groupedFavoriteNews[favoriteNews.sourceName] == null) _groupedFavoriteNews[favoriteNews.sourceName] = [];
      _groupedFavoriteNews[favoriteNews.sourceName]?.add(favoriteNews);
    }
  }

  ArticleEntity _makeArticleFromFavoriteArticle(FavoriteArticleEntity favoriteArticle) {
    return ArticleEntity(
      author: favoriteArticle.author,
      title: favoriteArticle.title,
      description: favoriteArticle.description,
      content: favoriteArticle.content,
      sourceName: favoriteArticle.sourceName,
      url: favoriteArticle.url,
      urlToImage: favoriteArticle.urlToImage,
      publishedAt: favoriteArticle.publishedAt,
    );
  }

  FavoriteArticleEntity _makeFavoriteArticleFromArticle(int id, ArticleEntity article) {
    return FavoriteArticleEntity(
      id: id,
      author: article.author,
      title: article.title,
      description: article.description,
      content: article.content,
      sourceName: article.sourceName,
      url: article.url,
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
    );
  }

  void _matchFavoriteNews() {
    _groupedFavoriteNews.forEach((favoriteKey, favoriteArticles) {
      if (_groupedNews.containsKey(favoriteKey)) {
        final articles = _groupedNews[favoriteKey]!;
        for (var favoriteArticle in favoriteArticles) {
          final index = articles.indexWhere((article) => article.title == favoriteArticle.title);
          if (index != -1) articles[index] = favoriteArticle;
        }
      }
    });
  }

  void _removeArticleFromGroupedFavoriteNews(FavoriteArticleEntity favoriteArticle) {
    _groupedFavoriteNews[favoriteArticle.sourceName]?.remove(favoriteArticle);
    if (_groupedFavoriteNews[favoriteArticle.sourceName]?.isEmpty == true) {
      _groupedFavoriteNews.remove(favoriteArticle.sourceName);
    }
  }

  void _setLoadingState() {
    emit(SearchLoadingState());
  }

  void _setSuccessState() {
    emit(SearchSuccessState());
  }

  void _setErrorState(String message) {
    emit(SearchErrorState('An error occurred while searching for news. Please, try again!'));
  }

  void _updateArticleAsFavoriteInGroupedNews(ArticleEntity article, FavoriteArticleEntity favoriteArticle) {
    final index = _groupedNews[article.sourceName]!.indexOf(article);
    _groupedNews[article.sourceName]![index] = favoriteArticle;
    _groupedFavoriteNews[article.sourceName] = [..._groupedFavoriteNews[article.sourceName] ?? [], favoriteArticle];
  }

  void _updateFavoriteArticleAsArticleInGroupedNews(ArticleEntity article, FavoriteArticleEntity favoriteArticle) {
    final index = _groupedNews[favoriteArticle.sourceName]?.indexOf(favoriteArticle) ?? -1;
    if (index != -1) {
      _groupedNews[favoriteArticle.sourceName]![index] = article;
    }
  }

  @override
  String keyword = '';

  @override
  void onKeywordChanged(String value) {
    keyword = value;
  }

  @override
  Map<String, List<ArticleEntity>> get groupedNews => _groupedNews;

  @override
  Future<void> getNews() async {
    try {
      _setLoadingState();
      final newsList = await findArticleByKeyword(keyword);
      _fillGroupedNews(newsList);
      _matchFavoriteNews();
      _setSuccessState();
    } catch (_) {
      _setErrorState('An error occurred while searching for news. Please, try again!');
    }
  }

  @override
  Map<String, List<FavoriteArticleEntity>> get groupedFavoriteNews => _groupedFavoriteNews;

  @override
  Future<void> getFavoriteNews() async {
    try {
      _setLoadingState();
      final favoriteNewsList = await getFavoriteArticles();
      _fillGroupedFavoriteNews(favoriteNewsList);
      _setSuccessState();
    } catch (_) {
      _setErrorState('An error occurred while searching for favorite news. Please, try again!');
    }
  }

  @override
  Future<void> addFavorite(ArticleEntity article) async {
    try {
      final id = await saveArticleAsFavorite(article);
      final favoriteArticle = _makeFavoriteArticleFromArticle(id, article);
      _updateArticleAsFavoriteInGroupedNews(article, favoriteArticle);
      _setSuccessState();
    } catch (_) {
      _setErrorState('An error occurred while adding a news item as a favorite. Please, try again!');
    }
  }

  @override
  Future<void> removeFavorite(FavoriteArticleEntity favoriteArticle) async {
    try {
      await removeArticleFromFavorites(favoriteArticle.id);
      _removeArticleFromGroupedFavoriteNews(favoriteArticle);
      final article = _makeArticleFromFavoriteArticle(favoriteArticle);
      _updateFavoriteArticleAsArticleInGroupedNews(article, favoriteArticle);
      _setSuccessState();
    } catch (_) {
      _setErrorState('An error occurred while removing a news item from favorites. Please, try again!');
    }
  }

  var _currentTab = 0;

  @override
  int get currentTab => _currentTab;

  @override
  void onTabChanged(int tabIndex) {
    emit(SearchInitialState());
    _currentTab = tabIndex;
    emit(SearchTabState());
  }

  @override
  void dispose() {
    keyword = '';
    _currentTab = 0;
    _timer?.cancel();
    _groupedNews.clear();
    _groupedFavoriteNews.clear();
  }
}
