import 'dart:convert';

import '../../core/config/config.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/cache/cache.dart';
import '../models/models.dart';

class LocalGetFavoriteArticles implements GetFavoriteArticles {
  final FetchCache cache;

  LocalGetFavoriteArticles({
    required this.cache,
  });

  @override
  Future<List<FavoriteArticleEntity>> call() async {
    try {
      final result = await cache.fetch(ENV.favoriteTableName);
      if (result == null) return [];
      final jsonDecoded = jsonDecode(result);
      return (jsonDecoded as List).map((article) => LocalArticleModel.fromJson(article).toEntity()).toList();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
