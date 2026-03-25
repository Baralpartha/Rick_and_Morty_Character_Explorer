import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class AppStartup {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Map>(AppConstants.charactersBox),
      Hive.openBox(AppConstants.favoritesBox),
      Hive.openBox<Map>(AppConstants.editsBox),
      Hive.openBox(AppConstants.metaBox),
    ]);
  }
}
