import 'package:dio/dio.dart';

import '../../../../core/network/token_storage.dart';
import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repos/auth_repo.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remote;

  AuthRepoImpl(this._remote);

  @override
  Future<AuthTokensEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remote.login(email: email, password: password);
      TokenStorage.accessToken = result.accessToken;
      TokenStorage.refreshToken = result.refreshToken;
      return result;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email or password is incorrect');
      }
      throw Exception('Something went wrong, check your internet');
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _remote.register(name: name, email: email, password: password);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid data or this email is already used');
      }
      throw Exception('Something went wrong, check your internet');
    }
  }

  @override
  Future<UserEntity> getProfile() async {
    final token = TokenStorage.accessToken;
    if (token == null) {
      throw Exception('Session expired, please login again');
    }
    try {
      return await _remote.getProfile(token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session expired, please login again');
      }
      throw Exception('Something went wrong, check your internet');
    }
  }
}