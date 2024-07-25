import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../core/config/config.dart';
import 'cache.dart';

class SqliteDatabaseAdapter implements SaveCache<int>, FetchCache, DeleteCache {
  late Database _db;

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), ENV.databaseName),
      onCreate: (db, version) => db.execute(ENV.createFavoriteTableScript),
      version: 1,
    );
  }

  @override
  Future<String?> fetch(String key) async {
    _db = await _getDatabase();
    try {
      final commandSQL = 'SELECT * FROM $key';
      return jsonEncode(await _db.rawQuery(commandSQL));
    } catch (_) {
      throw CacheError.unexpected;
    } finally {
      _db.close();
    }
  }

  @override
  Future<int> save({required String key, String? value}) async {
    _db = await _getDatabase();
    try {
      final commandSQL = 'INSERT INTO $key $value';
      return await _db.rawInsert(commandSQL);
    } catch (_) {
      throw CacheError.unexpected;
    } finally {
      _db.close();
    }
  }

  @override
  Future<void> delete(String key) async {
    _db = await _getDatabase();
    try {
      final query = 'DELETE FROM $key';
      await _db.rawInsert(query);
    } catch (_) {
      throw CacheError.unexpected;
    } finally {
      _db.close();
    }
  }
}
