import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ENV {
  static final env = dotenv.env;
  static String apiKey = env['API_KEY']!;
  static String baseUrl = env['BASE_URL']!;
  static String databaseName = env['DATABASE_NAME']!;
  static String favoriteTableName = env['FAVORITE_TABLE_NAME']!;
  static String createFavoriteTableScript = env['CREATE_FAVORITE_TABLE_SCRIPT']!;
}
