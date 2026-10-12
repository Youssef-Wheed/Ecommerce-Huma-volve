import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class HomeRepo {
  Future<List<ProductEntity>> getProducts({int offset = 0, int limit = 10});
  Future<List<CategoryEntity>> getCategories();
}