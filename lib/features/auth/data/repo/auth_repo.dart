
import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../models/login_response_model.dart';

class AuthRepo {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email or password is incorrect');
      }
      throw Exception('Something went wrong, check your internet');
    }
  }

  // Register
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'avatar': 'https://picsum.photos/800',
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid data or this email is already used');
      }
      throw Exception('Something went wrong, check your internet');
    }
  }
}
