import '../entities/product_entity.dart';
import '../repos/home_repo.dart';
class GetProductByIdUseCase {
  final HomeRepo _repo;

  GetProductByIdUseCase(this._repo);

  Future<ProductEntity> call(int id) {
    return _repo.getProductById(id);
  }
}