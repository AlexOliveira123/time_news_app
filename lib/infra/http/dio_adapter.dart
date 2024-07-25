import 'dart:convert';

import 'package:dio/dio.dart';

import 'http_client.dart';
import 'http_error.dart';

class DioAdapter implements HttpClient {
  final Dio client;

  DioAdapter(this.client);

  Future<Map?> request({required String url, required String method, Map? data}) async {
    final jsonData = data != null ? jsonEncode(data) : null;
    Response response;

    try {
      if (method == 'get') {
        response = await client.get(url);
      } else {
        response = await client.post(url, data: jsonData);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map? _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.data?.isNotEmpty == true ? Map.from(response.data) : null;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbbiden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
