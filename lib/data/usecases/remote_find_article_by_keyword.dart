import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../infra/http/http.dart';
import '../models/models.dart';

class RemoteFindArticleByKeyword implements FindArticleByKeyword {
  final HttpClient httpClient;
  final String url;

  RemoteFindArticleByKeyword({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<List<ArticleEntity>> call(String keyword) async {
    try {
      if (keyword.length < 4) return [];
      final httpResponse = await httpClient.request(url: '$url?q=$keyword', method: 'get');
      final articleList = (httpResponse['articles'] as List);
      articleList.removeWhere((item) => (item['description'] ?? '').contains('[Removed]'));
      return articleList.map((json) => RemoteArticleModel.fromJson(json).toEntity()).toList();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized ? DomainError.invalidCredentials : DomainError.unexpected;
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
