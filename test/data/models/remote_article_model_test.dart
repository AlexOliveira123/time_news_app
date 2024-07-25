import 'package:flutter_test/flutter_test.dart';
import 'package:time_news_app/data/models/models.dart';
import 'package:time_news_app/domain/entities/entities.dart';
import 'package:time_news_app/domain/helpers/helpers.dart';

import '../../core/factories/factories.dart';

void main() {
  late Map remoteArticlesJson;
  late RemoteArticleModel remoteArticleModel;
  late Map invalidJson;

  setUp(() {
    remoteArticlesJson = makeRemoteArticlesJson();
    remoteArticleModel = makeRemoteArticleModel();
    invalidJson = makeInvalidJson();
  });

  test('Should create RemoteArticleModel object when json is valid', () async {
    final json = RemoteArticleModel.fromJson(remoteArticlesJson['articles'][0]);
    expect(json, isA<RemoteArticleModel>());
  });

  test('Should throw a unexpected error when json is not valid', () async {
    expect(() => RemoteArticleModel.fromJson(invalidJson), throwsA(DomainError.unexpected));
  });

  test('Should create a FavoriteArticleEntity object', () async {
    final result = remoteArticleModel.toEntity();
    expect(result, isA<ArticleEntity>());
  });
}
