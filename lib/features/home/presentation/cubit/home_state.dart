import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final HomeStatus status;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final String? errorMessage;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const HomeState({
    this.status = HomeStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.errorMessage,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    String? errorMessage,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}