import '../entities/product_entity.dart';
import '../repos/home_repo.dart';

class GetProductsUseCase {
  final HomeRepo _repo;

  GetProductsUseCase(this._repo);

  Future<List<ProductEntity>> call({int offset = 0, int limit = 10}) {
    return _repo.getProducts(offset: offset, limit: limit);
  }
}