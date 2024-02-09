import 'package:flutter_dotenv/flutter_dotenv.dart';

class Secrets {
  static String get realmAppId => dotenv.env['REALM_APP_ID'] ?? '';
}
