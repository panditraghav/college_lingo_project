import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io'; // For Directory

class ApiService {
  late Dio _dio;
  late PersistCookieJar _cookieJar;

  ApiService() {
    _dio = Dio();
    _setupDio();
  }

  Dio get dio => _dio; // Getter to access the Dio instance

  Future<void> _setupDio() async {
    // Get application documents directory for persistent cookies
    final appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final String cookieDirPath = '$appDocPath/cookies';
    final Directory cookieDir = Directory(cookieDirPath);

    if (!await cookieDir.exists()) {
      await cookieDir.create(recursive: true);
    }

    _cookieJar = PersistCookieJar(storage: FileStorage(cookieDirPath));

    // Add CookieManager to Dio
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Optional: Add other interceptors like LogInterceptor for debugging
    // _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    // Optional: Set base options for Dio
    _dio.options.baseUrl = dotenv.env['NODE_BACKEND_BASE']!;
    _dio.options.connectTimeout = const Duration(seconds: 5); // 5 seconds
    _dio.options.receiveTimeout = const Duration(seconds: 3); // 3 seconds
  }

  // Example API calls
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio errors (e.g., network issues, server errors)
      print('Login error: $e');
      rethrow;
    }
  }

  Future<Response> getUserProfile() async {
    try {
      final response = await _dio.get('/profile');
      return response;
    } on DioException catch (e) {
      print('Get profile error: $e');
      rethrow;
    }
  }

  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
    print('All cookies cleared.');
  }
}
