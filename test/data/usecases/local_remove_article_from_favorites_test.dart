import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:time_news_app/data/usecases/usecases.dart';
import 'package:time_news_app/domain/helpers/helpers.dart';
import 'package:time_news_app/infra/cache/cache.dart';

import '../../core/factories/factories.dart';
import '../../core/helpers/helpers.dart';

class DeleteCacheSpy extends Mock implements DeleteCache {}

void main() {
  late LocalRemoveArticleFromFavorites sut;
  late DeleteCacheSpy deleteCache;
  late int id;

  When mockDeleteCall() => when(() => deleteCache.delete(any()));

  void mockDelete() {
    mockDeleteCall().thenAnswer((_) async => jsonEncode(makeLocalArticlesJson()));
  }

  void mockFetchError() {
    mockDeleteCall().thenThrow(Exception());
  }

  setUp(() {
    deleteCache = DeleteCacheSpy();
    id = faker.randomGenerator.integer(10);
    sut = LocalRemoveArticleFromFavorites(cache: deleteCache);
    mockDelete();
  });

  setUpAll(() {
    loadEnv();
  });

  test('Should call deleteCache with correct value', () async {
    await sut(id);
    verify(() => deleteCache.delete(any()));
  });

  test('Should throw UnexpectedError if deleteCache throws', () async {
    mockFetchError();
    final future = sut(id);
    expect(future, throwsA(DomainError.unexpected));
  });
}
