import '../entities/auth_tokens_entity.dart';
import '../repos/auth_repo.dart';

class LoginUseCase {
  final AuthRepo _repo;

  LoginUseCase(this._repo);

  Future<AuthTokensEntity> call({
    required String email,
    required String password,
  }) {
    return _repo.login(email: email, password: password);
  }
}