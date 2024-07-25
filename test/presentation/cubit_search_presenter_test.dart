import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_news_app/domain/entities/entities.dart';
import 'package:time_news_app/domain/helpers/helpers.dart';
import 'package:time_news_app/domain/usecases/usecases.dart';
import 'package:time_news_app/presentation/presentation.dart';

import '../core/factories/factories.dart';

class SpyFindArticleByKeyword extends Mock implements FindArticleByKeyword {}

class SpyGetFavoriteArticles extends Mock implements GetFavoriteArticles {}

class SpySaveArticleAsFavorite extends Mock implements SaveArticleAsFavorite {}

class SpyRemoveArticleFromFavorites extends Mock implements RemoveArticleFromFavorites {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

class FakeFavoriteArticleEntity extends Fake implements FavoriteArticleEntity {}

void main() {
  late FindArticleByKeyword findArticleByKeyword;
  late GetFavoriteArticles getFavoriteArticles;
  late SaveArticleAsFavorite saveArticleAsFavorite;
  late RemoveArticleFromFavorites removeArticleFromFavorites;
  late CubitSearchPresenter sut;
  late List<ArticleEntity> articles;
  late ArticleEntity articleEntity;
  late List<FavoriteArticleEntity> favoriteArticles;
  late int id;

  When mockFindArticleByKeywordCall() {
    return when(() => findArticleByKeyword(any()));
  }

  void mockFindArticleByKeywordSuccess() {
    mockFindArticleByKeywordCall().thenAnswer((_) => Future.value(articles));
  }

  void mockFindArticleByKeywordError() {
    mockFindArticleByKeywordCall().thenThrow(DomainError.unexpected);
  }

  When mockGetFavoriteArticlesCall() {
    return when(() => getFavoriteArticles());
  }

  void mockGetFavoriteArticlesSuccess() {
    mockGetFavoriteArticlesCall().thenAnswer((_) => Future.value(favoriteArticles));
  }

  void mockGetFavoriteArticlesError() {
    mockGetFavoriteArticlesCall().thenThrow(DomainError.unexpected);
  }

  When mockSaveArticleAsFavoriteCall() {
    return when(() => saveArticleAsFavorite(any()));
  }

  void mockSaveArticleAsFavoriteSuccess() {
    mockSaveArticleAsFavoriteCall().thenAnswer((_) => Future.value(id));
  }

  void mockSaveArticleAsFavoriteError() {
    mockSaveArticleAsFavoriteCall().thenThrow(DomainError.unexpected);
  }

  When mockRemoveArticleFromFavoritesCall() {
    return when(() => removeArticleFromFavorites(any()));
  }

  void mockRemoveArticleFromFavoritesSuccess() {
    mockRemoveArticleFromFavoritesCall().thenAnswer((_) => Future.value(id));
  }

  void mockRemoveArticleFromFavoritesError() {
    mockRemoveArticleFromFavoritesCall().thenThrow(DomainError.unexpected);
  }

  void expectSuccessFlowEventsEmitted() {
    expectLater(
      sut.stream,
      emitsInOrder([isA<SearchLoadingState>(), isA<SearchSuccessState>()]),
    );
  }

  void expectErrorFlowEventsEmitted() {
    expectLater(
      sut.stream,
      emitsInOrder([isA<SearchLoadingState>(), isA<SearchErrorState>()]),
    );
  }

  void expectSuccessEmitted() {
    expectLater(sut.stream, emits(isA<SearchSuccessState>()));
  }

  void expectErrorEmitted() {
    expectLater(sut.stream, emits(isA<SearchErrorState>()));
  }

  setUp(() {
    findArticleByKeyword = SpyFindArticleByKeyword();
    getFavoriteArticles = SpyGetFavoriteArticles();
    saveArticleAsFavorite = SpySaveArticleAsFavorite();
    removeArticleFromFavorites = SpyRemoveArticleFromFavorites();

    sut = CubitSearchPresenter(
      findArticleByKeyword: findArticleByKeyword,
      getFavoriteArticles: getFavoriteArticles,
      saveArticleAsFavorite: saveArticleAsFavorite,
      removeArticleFromFavorites: removeArticleFromFavorites,
    );

    articles = makeArticleEntityList();
    articleEntity = articles[0];
    favoriteArticles = makeFavoriteArticleEntityList();
    id = faker.randomGenerator.integer(10);

    mockFindArticleByKeywordSuccess();
    mockGetFavoriteArticlesSuccess();
    mockSaveArticleAsFavoriteSuccess();
    mockRemoveArticleFromFavoritesSuccess();
  });

  setUpAll(() {
    registerFallbackValue(FakeArticleEntity());
    registerFallbackValue(FakeFavoriteArticleEntity());
  });

  group('onKeywordChanged', () {
    test('Should change keyword variable when onKeywordChanged was called', () async {
      expect(sut.keyword, isEmpty);
      sut.onKeywordChanged('any_keyword');
      expect(sut.keyword, 'any_keyword');
    });
  });

  group('getNews', () {
    test('Should emits [SearchLoadingState, SearchSuccessState] when getNews was success', () async {
      expectSuccessFlowEventsEmitted();
      await sut.getNews();
    });

    test('Should groupedNews is not empty when getNews was success', () async {
      expect(sut.groupedNews.isEmpty, isTrue);
      await sut.getNews();
      expect(sut.groupedNews.isNotEmpty, isTrue);
    });

    test('Should emits [SearchLoadingState, SearchErrorState] when getNews fails', () async {
      mockFindArticleByKeywordError();
      expectErrorFlowEventsEmitted();
      await sut.getNews();
    });
  });

  group('getFavoriteNews', () {
    test('Should emits [SearchLoadingState, SearchSuccessState] when getFavoriteNews was success', () async {
      expectSuccessFlowEventsEmitted();
      await sut.getFavoriteNews();
    });

    test('Should groupedFavoriteNews is not empty when getFavoriteNews was success', () async {
      expect(sut.groupedFavoriteNews.isEmpty, isTrue);
      await sut.getFavoriteNews();
      expect(sut.groupedFavoriteNews.isNotEmpty, isTrue);
    });

    test('Should emits [SearchLoadingState, SearchErrorState] when getFavoriteNews fails', () async {
      mockGetFavoriteArticlesError();
      expectErrorFlowEventsEmitted();
      await sut.getFavoriteNews();
    });
  });

  group('addFavorite', () {
    setUp(() {
      sut.getNews();
    });

    test('Should emits [SearchSuccessState] when addFavorite was success', () async {
      expectSuccessEmitted();
      await sut.addFavorite(articleEntity);
    });

    test('Should groupedFavoriteNews have article added as favorite when addFavorite was success', () async {
      await sut.addFavorite(articleEntity);
      final favoriteArticleEntity = makeFavoriteArticleEntityFromArticleEntity(id, articleEntity);
      expect(sut.groupedFavoriteNews[articleEntity.sourceName]?.contains(favoriteArticleEntity), isTrue);
    });

    test('Should groupedNews have article added as favorite when addFavorite was success', () async {
      await sut.addFavorite(articleEntity);
      final favoriteArticleEntity = makeFavoriteArticleEntityFromArticleEntity(id, articleEntity);
      expect(sut.groupedNews[articleEntity.sourceName]?.contains(favoriteArticleEntity), isTrue);
    });

    test('Should emits [SearchErrorState] when addFavorite fails', () async {
      mockSaveArticleAsFavoriteError();
      expectErrorEmitted();
      await sut.addFavorite(articleEntity);
    });
  });

  group('removeFavorite', () {
    late FavoriteArticleEntity favoriteArticleEntity;

    setUp(() {
      sut.getNews();
      sut.addFavorite(articleEntity);
      favoriteArticleEntity = makeFavoriteArticleEntityFromArticleEntity(id, articleEntity);
    });

    test('Should emits [SearchSuccessState] when removeFavorite was success', () async {
      expectSuccessEmitted();
      await sut.removeFavorite(favoriteArticleEntity);
    });

    test('Should groupedFavoriteNews remove article as favorite when removeFavorite was success', () async {
      expect(sut.groupedFavoriteNews[articleEntity.sourceName]?.contains(favoriteArticleEntity), isTrue);
      await sut.removeFavorite(favoriteArticleEntity);
      expect(sut.groupedFavoriteNews.isEmpty, isTrue);
    });

    test('Should groupedNews remove article as favorite when removeFavorite was success', () async {
      expect(sut.groupedNews[articleEntity.sourceName]?.contains(favoriteArticleEntity), isTrue);
      await sut.removeFavorite(favoriteArticleEntity);
      expect(sut.groupedNews[articleEntity.sourceName]?.contains(favoriteArticleEntity), isFalse);
    });

    test('Should emits [SearchLoadingState, SearchErrorState] when removeFavorite fails', () async {
      mockRemoveArticleFromFavoritesError();
      expectErrorEmitted();
      await sut.removeFavorite(favoriteArticleEntity);
    });
  });

  group(
    'onTabChanged',
    () {
      test('Should emits [SearchInitialState, SearchTabState] when onTabChanged was called', () {
        expectLater(sut.stream, emitsInOrder([isA<SearchInitialState>(), isA<SearchTabState>()]));
        sut.onTabChanged(1);
      });

      test('Should currentTab changes when onTabChanged was called', () {
        expect(sut.currentTab, 0);
        sut.onTabChanged(1);
        expect(sut.currentTab, 1);
      });
    },
  );

  group(
    'dispose',
    () {
      setUp(() {
        sut.getNews();
        sut.onKeywordChanged('any');
        sut.addFavorite(articleEntity);
        sut.onTabChanged(1);
      });

      test(
        'Should dispose method be executed correctly',
        () {
          expect(sut.keyword, 'any');
          expect(sut.currentTab, 1);
          expect(sut.groupedFavoriteNews, isNotEmpty);
          expect(sut.groupedNews, isNotEmpty);
          sut.dispose();
          expect(sut.keyword, isEmpty);
          expect(sut.currentTab, 0);
          expect(sut.groupedFavoriteNews, isEmpty);
          expect(sut.groupedNews, isEmpty);
        },
      );
    },
  );
}
