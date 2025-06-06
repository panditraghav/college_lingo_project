import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lingo/models/ReportModel.dart';
import 'package:lingo/models/lessons.dart';
import 'package:lingo/models/test.dart';
import 'package:logger/logger.dart';

class ApiService {
  final _dio = Dio();
  final _storage = FlutterSecureStorage();
  final logger = Logger();

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
            options.headers['Authorization'] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio; // Getter to access the Dio instance

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio errors (e.g., network issues, server errors)
      logger.e('Login error: $e');
      rethrow;
    }
  }

  Future<Response> signup({
    required String email,
    required String password,
    required String fullName,
    required String age,
    required String dateOfBirth,
    required String gender,
    required String phoneNumber,
    required File file,
  }) async {
    try {
      FormData data = FormData.fromMap({
        "email": email,
        "password": password,
        "fullName": fullName,
        "age": age,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "phoneNumber": phoneNumber,
        "file": MultipartFile.fromFile(file.path),
      });
      final response = await _dio.post('/user/register', data: data);
      return response;
    } on DioException catch (e) {
      logger.e('Signup error: $e');
      rethrow;
    }
  }

  Future<LessonsModel> getBeginnerLessons() async {
    try {
      final response = await _dio.get('/lessons/getbeginnerlessons');
      final model = LessonsModel.fromJson(response.data);
      return model;
    } on DioException catch (e) {
      // Handle Dio errors (e.g., network issues, server errors)
      logger.e('Login error: $e');
      rethrow;
    }
  }

  Future<LessonsModel> getIntermediateLessons() async {
    try {
      final response = await _dio.get('/lessons/getintermediatelessons');
      final model = LessonsModel.fromJson(response.data);
      return model;
    } on DioException catch (e) {
      // Handle Dio errors (e.g., network issues, server errors)
      logger.e('Login error: $e');
      rethrow;
    }
  }

  Future<LessonsModel> getAdvancedLessons() async {
    try {
      final response = await _dio.get('/lessons/getadvancedlessons');
      final model = LessonsModel.fromJson(response.data);
      return model;
    } on DioException catch (e) {
      // Handle Dio errors (e.g., network issues, server errors)
      logger.e('Login error: $e');
      rethrow;
    }
  }

  Future<Response> updateStatus(String lessonId) async {
    try {
      logger.i("Update status id: $lessonId");
      final response = await _dio.post('/lessons/update/$lessonId');
      return response;
    } on DioException catch (e) {
      logger.e('Unable to update : $e');
      rethrow;
    }
  }

  Future<Response> getProgress() async {
    try {
      final response = await _dio.get('/user/progress');
      return response;
    } on DioException catch (e) {
      logger.e('Unable to fetch the progress : $e');
      rethrow;
    }
  }

  Future<ReportModel> getReport() async {
    try {
      final response = await _dio.get('/test/getreport/');
      final model = ReportModel.fromJson(response.data);
      return model;
    } on DioException catch (e) {
      logger.e("getReport error: $e");
      rethrow;
    }
  }

  Future<Response> getUserProfile() async {
    try {
      final response = await _dio.get('/profile');
      return response;
    } on DioException catch (e) {
      logger.e('Get profile error: $e');
      rethrow;
    }
  }

  Future<TestsWithStatus> getTestsWithStatus() async {
    try {
      final response = await _dio.get('/test/get');
      return TestsWithStatus.fromJson(response.data);
    } on DioException catch (e) {
      logger.e('Get profile error: $e');
      rethrow;
    }
  }

  Future<TestModel> getSingleTest(String testId) async {
    try {
      final response = await _dio.get('/test/getsingletest/$testId');
      return TestModel.fromJson(response.data['requiredTest']);
    } on DioException catch (e) {
      logger.e('Get single test error: $e');
      rethrow;
    }
  }

  Future submitTest(String testId, List<Answer> answers) async {
    try {
      Map<String, dynamic> data = {};
      data['testId'] = testId;

      final ansList =
          answers.map((answer) {
            return answer.toJson();
          }).toList();
      data['answers'] = ansList;

      await _dio.post('/test/submit/', data: data);
    } on DioException catch (e) {
      logger.e('submitTest error: $e');
      rethrow;
    }
  }

  Future<TestResult> getTestResult(String testId) async {
    try {
      final response = await _dio.get('/test/gettestresult/$testId');
      return TestResult.fromJson(response.data['testResult']);
    } on DioException catch (e) {
      logger.e('getTestResult error: $e');
      rethrow;
    }
  }
}
