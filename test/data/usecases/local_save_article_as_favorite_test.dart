import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:time_news_app/data/usecases/usecases.dart';
import 'package:time_news_app/domain/entities/entities.dart';
import 'package:time_news_app/domain/helpers/helpers.dart';
import 'package:time_news_app/infra/cache/cache.dart';

import '../../core/factories/factories.dart';
import '../../core/helpers/helpers.dart';

class SaveCacheSpy extends Mock implements SaveCache<int> {}

void main() {
  late SaveCacheSpy saveCache;
  late LocalSaveArticleAsFavorite sut;
  late ArticleEntity articleEntity;

  When mockSaveCall() {
    return when(() => saveCache.save(key: any(named: 'key'), value: any(named: 'value')));
  }

  void mockSave() {
    mockSaveCall().thenAnswer((_) async => faker.randomGenerator.integer(10));
  }

  void mockSaveError() {
    mockSaveCall().thenThrow(Exception());
  }

  setUp(() {
    saveCache = SaveCacheSpy();
    sut = LocalSaveArticleAsFavorite(cache: saveCache);
    articleEntity = makeArticleEntity();
    mockSave();
  });

  setUpAll(() {
    loadEnv();
  });

  test('Should call SaveCache with correct value', () async {
    await sut(articleEntity);
    verify(() => saveCache.save(key: any(named: 'key'), value: any(named: 'value')));
  });

  test('Should return an int value', () async {
    final result = await sut(articleEntity);
    expect(result, isA<int>());
  });

  test('Should throw UnexpectedError if saveCache throws', () async {
    mockSaveError();
    final future = sut(articleEntity);
    expect(future, throwsA(DomainError.unexpected));
  });
}
