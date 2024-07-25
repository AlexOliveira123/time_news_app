import 'package:flutter_test/flutter_test.dart';
import 'package:time_news_app/data/models/models.dart';
import 'package:time_news_app/domain/entities/entities.dart';
import 'package:time_news_app/domain/helpers/helpers.dart';

import '../../core/factories/factories.dart';

void main() {
  late List<Map> localArticlesJson;
  late LocalArticleModel localArticleModel;
  late ArticleEntity articleEntity;
  late Map invalidJson;

  setUp(() {
    localArticlesJson = makeLocalArticlesJson();
    localArticleModel = makeLocalArticleModel();
    articleEntity = makeArticleEntity();
    invalidJson = makeInvalidJson();
  });

  test('Should create LocalArticleModel object when json is valid', () async {
    final json = LocalArticleModel.fromJson(localArticlesJson[0]);
    expect(json, isA<LocalArticleModel>());
  });

  test('Should create LocalArticleModel object from ArticleEntity object', () async {
    final json = LocalArticleModel.fromEntity(articleEntity);
    expect(json, isA<LocalArticleModel>());
  });

  test('Should throw a unexpected error when json is not valid', () async {
    expect(() => LocalArticleModel.fromJson(invalidJson), throwsA(DomainError.unexpected));
  });

  test('Should create a FavoriteArticleEntity object', () async {
    final result = localArticleModel.toEntity();
    expect(result, isA<FavoriteArticleEntity>());
  });

  test('Should create a FavoriteArticleEntity object', () async {
    final result = localArticleModel.toEntity();
    expect(result, isA<FavoriteArticleEntity>());
  });

  test('Should create a String from LocalArticleModel', () async {
    final result = localArticleModel.toDataString();
    expect(result, isA<String>());
  });
}
