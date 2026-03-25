import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );
  }
}
