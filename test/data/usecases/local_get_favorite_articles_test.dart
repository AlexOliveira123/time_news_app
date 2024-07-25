import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:time_news_app/data/usecases/usecases.dart';
import 'package:time_news_app/domain/entities/entities.dart';
import 'package:time_news_app/domain/helpers/helpers.dart';
import 'package:time_news_app/infra/cache/cache.dart';

import '../../core/factories/factories.dart';
import '../../core/helpers/helpers.dart';

class FetchCacheSpy extends Mock implements FetchCache {}

void main() {
  late LocalGetFavoriteArticles sut;
  late FetchCacheSpy fetchCache;

  When mockFetchCall() => when(() => fetchCache.fetch(any()));

  void mockFetch() {
    mockFetchCall().thenAnswer((_) async => jsonEncode(makeLocalArticlesJson()));
  }

  void mockFetchError() {
    mockFetchCall().thenThrow(Exception());
  }

  setUp(() {
    fetchCache = FetchCacheSpy();
    sut = LocalGetFavoriteArticles(cache: fetchCache);
    mockFetch();
  });

  setUpAll(() {
    loadEnv();
  });

  test('Should call fetchCache with correct value', () async {
    await sut();
    verify(() => fetchCache.fetch(any()));
  });

  test('Should return an List<FavoriteArticleEntity>', () async {
    final result = await sut();
    expect(result, isA<List<FavoriteArticleEntity>>());
  });

  test('Should throw UnexpectedError if fetchCache throws', () async {
    mockFetchError();
    final future = sut();
    expect(future, throwsA(DomainError.unexpected));
  });
}
