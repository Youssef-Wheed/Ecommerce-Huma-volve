
import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/token_storage.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthRepo {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiConstants.baseUrl),
  );

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final result = LoginResponseModel.fromJson(response.data);

      TokenStorage.accessToken = result.accessToken;
      TokenStorage.refreshToken = result.refreshToken;

      return result;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email or password is incorrect');
      }
      throw Exception(
        'Something went wrong, check your internet',
      );
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
        throw Exception(
          'Invalid data or this email is already used',
        );
      }
      throw Exception(
        'Something went wrong, check your internet',
      );
    }
  }

  // Get Profile
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(
        ApiConstants.profile,
        options: Options(
          headers: {
            'Authorization':
            'Bearer ${TokenStorage.accessToken}',
          },
        ),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(
          'Session expired, please login again',
        );
      }
      throw Exception(
        'Something went wrong, check your internet',
      );
    }
  }
}
