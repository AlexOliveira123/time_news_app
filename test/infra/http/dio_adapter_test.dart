import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_news_app/infra/http/http.dart';

class DioSpy extends Mock implements Dio {}

class UriFake extends Fake implements Uri {}

void main() {
  late DioAdapter sut;
  late DioSpy client;
  late String url;

  setUp(() {
    client = DioSpy();
    sut = DioAdapter(client);
    url = faker.internet.httpUrl();
  });

  Response mockDioResponse({Map? data, int statusCode = 200}) {
    return Response(
      data: data,
      statusCode: statusCode,
      requestOptions: RequestOptions(),
    );
  }

  group('shared', () {
    test('Should throw ServeError if invalid method is provided', () async {
      final future = sut.request(url: url, method: 'invalid_method');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    When mockRequest() {
      return when(() => client.post(any(), data: any(named: 'data')));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    void mockResponse(int statusCode, {Map? data = const {'any_key': 'any_value'}}) {
      mockRequest().thenAnswer((_) async => mockDioResponse(data: data, statusCode: statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(url: url, method: 'post', data: {'any_key': 'any_value'});
      verify(() => client.post(url, data: '{"any_key":"any_value"}'));
    });

    test('Should call post without data', () async {
      await sut.request(url: url, method: 'post');
      verify(() => client.post(any()));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');
      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, data: null);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnathorizedError if post returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbbiden));
    });

    test('Should return NotFoundError if post returns 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockError();
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('get', () {
    When mockRequest() {
      return when(() => client.get(any()));
    }

    void mockResponse(int statusCode, {Map? data = const {'any_key': 'any_value'}}) {
      mockRequest().thenAnswer((_) async => mockDioResponse(data: data, statusCode: statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });
    test('Should call get with correct values', () async {
      await sut.request(url: url, method: 'get');
      verify(() => client.get(url));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'get');
      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, data: null);
      final response = await sut.request(url: url, method: 'get');
      expect(response, null);
    });

    test('Should return null if get returns 204', () async {
      mockResponse(200, data: null);
      final response = await sut.request(url: url, method: 'get');
      expect(response, null);
    });

    test('Should return null if get returns 204 with data', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'get');
      expect(response, null);
    });

    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnathorizedError if get returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if get returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.forbbiden));
    });

    test('Should return NotFoundError if get returns 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if get returns 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if get throws', () async {
      mockError();
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
