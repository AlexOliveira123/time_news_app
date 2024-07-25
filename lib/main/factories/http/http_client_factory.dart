import 'package:dio/dio.dart';

import '../../../core/config/config.dart';
import '../../../infra/http/http.dart';

HttpClient makeDioAdapter() {
  final options = BaseOptions(
    baseUrl: ENV.baseUrl,
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
    contentType: 'application/json',
    headers: {
      'X-Api-Key': ENV.apiKey,
    },
  );
  final client = Dio(options)..interceptors.add(DioLoggerInterceptor());
  return DioAdapter(client);
}
