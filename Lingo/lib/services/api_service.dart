import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final _dio = Dio();
  final _storage = FlutterSecureStorage();

  ApiService() {
    _dio.options.baseUrl = dotenv.env['NODE_BACKEND_BASE']!;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) async {
          final token = await _storage.read(key: "token");
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio; // Getter to access the Dio instance

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
}
