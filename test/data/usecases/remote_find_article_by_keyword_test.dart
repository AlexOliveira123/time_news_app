import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_news_app/data/usecases/usecases.dart';
import 'package:time_news_app/domain/entities/entities.dart';
import 'package:time_news_app/domain/helpers/domain_error.dart';
import 'package:time_news_app/infra/http/http.dart';

import '../../core/factories/factories.dart';

class HttpClientSpy extends Mock implements HttpClient<Map> {}

void main() {
  late RemoteFindArticleByKeyword sut;
  late HttpClientSpy httpClient;
  late String url;
  late String keyword;
  late Map data;

  When mockRequest() {
    return when(
      () => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
      ),
    );
  }

  void mockHttpData(Map mockData) {
    data = mockData;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    keyword = 'any_keyword';
    httpClient = HttpClientSpy();
    sut = RemoteFindArticleByKeyword(url: url, httpClient: httpClient);
    mockHttpData(makeRemoteArticlesJson());
  });

  test('Should call HttpClient with correct values', () async {
    await sut(keyword);
    verify(() => httpClient.request(url: '$url?q=$keyword', method: 'get'));
  });

  test('Should return articles on 200', () async {
    final articles = await sut(keyword);
    expect(articles, isA<List<ArticleEntity>>());
    expect(articles, isNotEmpty);
  });

  test('Should return an empty list if keyword length is less than 4', () async {
    final articles = await sut('any');
    expect(articles, isA<List<ArticleEntity>>());
    expect(articles, isEmpty);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData({'invalid_key': 'invalid_value'});
    final future = sut(keyword);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut(keyword);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut(keyword);
    expect(future, throwsA(DomainError.unexpected));
  });
}
