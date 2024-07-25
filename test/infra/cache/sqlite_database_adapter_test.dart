import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:time_news_app/core/config/config.dart';
import 'package:time_news_app/infra/cache/cache.dart';

import '../../core/helpers/helpers.dart';

void main() {
  late Database db;
  late SqliteDatabaseAdapter sut;
  late String key;
  late String value;

  setUp(() async {
    databaseFactoryOrNull = null;
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    sut = SqliteDatabaseAdapter();
    key = ENV.favoriteTableName;
    value = '(author, title, description, content, sourceName, url, urlToImage, publishedAt) VALUES ("any_author", "any_title", "any_description", "any_content", "any_source", "any_url", "any_url_image", "03-03-2024")';
  });

  setUpAll(() {
    loadEnv();
  });

  tearDown(() {
    db.close();
  });

  group('save', () {
    test('Should call save with correct values and return an int value', () async {
      final id = await sut.save(key: key, value: value);
      expect(id, isA<int>());
    });

    test('Should throw if save throws', () async {
      final future = sut.save(key: key, value: value.replaceAll('description', ''));
      expect(future, throwsA(CacheError.unexpected));
    });
  });

  group('fetch', () {
    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);
      expect(fetchedValue, isA<String>());
    });

    test('Should throw if fetch throws', () async {
      final future = sut.fetch('wrong_key');
      expect(future, throwsA(CacheError.unexpected));
    });
  });

  group('delete', () {
    test('Should call delete with correct values', () async {
      final future = sut.delete(key);
      expect(future, completes);
    });

    test('Should throw if delete throws', () async {
      final future = sut.delete('wrong_key');
      expect(future, throwsA(CacheError.unexpected));
    });
  });
}
