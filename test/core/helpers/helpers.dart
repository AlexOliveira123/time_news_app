import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void loadEnv() {
  dotenv.testLoad(fileInput: File('.env').readAsStringSync());
}
