import 'package:faker/faker.dart';
import 'package:time_news_app/data/models/models.dart';
import 'package:time_news_app/domain/entities/entities.dart';

RemoteArticleModel makeRemoteArticleModel() {
  return RemoteArticleModel(
    author: faker.person.name(),
    title: faker.lorem.sentence(),
    description: faker.lorem.sentence(),
    content: faker.lorem.sentence(),
    sourceName: faker.lorem.sentence(),
    url: faker.internet.httpsUrl(),
    urlToImage: faker.image.image(),
    publishedAt: faker.date.dateTime().toIso8601String(),
  );
}

LocalArticleModel makeLocalArticleModel() {
  return LocalArticleModel(
    id: faker.randomGenerator.integer(10),
    author: faker.person.name(),
    title: faker.lorem.sentence(),
    description: faker.lorem.sentence(),
    content: faker.lorem.sentence(),
    sourceName: faker.lorem.sentence(),
    url: faker.internet.httpsUrl(),
    urlToImage: faker.image.image(),
    publishedAt: faker.date.dateTime().toIso8601String(),
  );
}

ArticleEntity makeArticleEntity() {
  return ArticleEntity(
    author: faker.person.name(),
    title: faker.lorem.sentence(),
    description: faker.lorem.sentence(),
    content: faker.lorem.sentence(),
    sourceName: faker.lorem.sentence(),
    url: faker.internet.httpsUrl(),
    urlToImage: faker.image.image(),
    publishedAt: faker.date.dateTime().toIso8601String(),
  );
}

List<ArticleEntity> makeArticleEntityList() {
  return List.generate(4, (index) => makeArticleEntity());
}

FavoriteArticleEntity makeFavoriteArticleEntity() {
  return FavoriteArticleEntity(
    id: faker.randomGenerator.integer(10),
    author: faker.person.name(),
    title: faker.lorem.sentence(),
    description: faker.lorem.sentence(),
    content: faker.lorem.sentence(),
    sourceName: faker.lorem.sentence(),
    url: faker.internet.httpsUrl(),
    urlToImage: faker.image.image(),
    publishedAt: faker.date.dateTime().toIso8601String(),
  );
}

FavoriteArticleEntity makeFavoriteArticleEntityFromArticleEntity(int id, ArticleEntity article) {
  return FavoriteArticleEntity(
    id: id,
    author: article.author,
    title: article.title,
    description: article.description,
    content: article.content,
    sourceName: article.sourceName,
    url: article.url,
    urlToImage: article.urlToImage,
    publishedAt: article.publishedAt,
  );
}

List<FavoriteArticleEntity> makeFavoriteArticleEntityList() {
  return List.generate(4, (index) => makeFavoriteArticleEntity());
}

Map makeRemoteArticlesJson() {
  return {
    'articles': [
      {
        'id': faker.randomGenerator.integer(10),
        'source': {'id': faker.guid.guid(), 'name': faker.lorem.sentence()},
        'author': faker.person.name(),
        'title': faker.lorem.word(),
        'description': faker.lorem.word(),
        'url': faker.internet.httpsUrl(),
        'urlToImage': faker.image.image(),
        'publishedAt': faker.date.dateTime().toIso8601String(),
        'content': faker.lorem.sentence(),
      },
      {
        'id': faker.randomGenerator.integer(10),
        'source': {'id': faker.guid.guid(), 'name': faker.lorem.sentence()},
        'author': faker.person.name(),
        'title': faker.lorem.word(),
        'description': faker.lorem.word(),
        'url': faker.internet.httpsUrl(),
        'urlToImage': faker.image.image(),
        'publishedAt': faker.date.dateTime().toIso8601String(),
        'content': faker.lorem.sentence(),
      },
    ],
  };
}

List<Map> makeLocalArticlesJson() {
  return [
    {
      'id': faker.randomGenerator.integer(10),
      'sourceName': faker.lorem.sentence(),
      'author': faker.person.name(),
      'title': faker.lorem.word(),
      'description': faker.lorem.word(),
      'url': faker.internet.httpsUrl(),
      'urlToImage': faker.image.image(),
      'publishedAt': faker.date.dateTime().toIso8601String(),
      'content': faker.lorem.sentence(),
    },
    {
      'id': faker.randomGenerator.integer(10),
      'sourceName': faker.lorem.sentence(),
      'author': faker.person.name(),
      'title': faker.lorem.word(),
      'description': faker.lorem.word(),
      'url': faker.internet.httpsUrl(),
      'urlToImage': faker.image.image(),
      'publishedAt': faker.date.dateTime().toIso8601String(),
      'content': faker.lorem.sentence(),
    },
  ];
}

Map makeInvalidJson() {
  return {
    'data': {
      'id': faker.randomGenerator.integer(10),
      'source': {'id': faker.guid.guid(), 'name': faker.lorem.sentence()},
      'author': faker.person.name(),
      'title': faker.lorem.word(),
    },
  };
}
