import '../entities/user_entity.dart';
import '../repos/auth_repo.dart';

class GetProfileUseCase {
  final AuthRepo _repo;

  GetProfileUseCase(this._repo);

  Future<UserEntity> call() {
    return _repo.getProfile();
  }
}