import '../data/models/category_model.dart';
import '../data/models/product_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final HomeStatus status;
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.errorMessage,
  });
}