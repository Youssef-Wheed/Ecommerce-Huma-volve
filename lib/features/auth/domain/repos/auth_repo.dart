import '../entities/auth_tokens_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<AuthTokensEntity> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserEntity> getProfile();
}