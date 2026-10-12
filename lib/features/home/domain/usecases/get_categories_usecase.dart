import '../entities/category_entity.dart';
import '../repos/home_repo.dart';

class GetCategoriesUseCase {
  final HomeRepo _repo;

  GetCategoriesUseCase(this._repo);

  Future<List<CategoryEntity>> call() {
    return _repo.getCategories();
  }
}