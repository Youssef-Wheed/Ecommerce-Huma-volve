import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;

  static const int _pageSize = 10;

  HomeCubit(this._getProducts, this._getCategories)
      : super(const HomeState());

  Future<void> loadHome() async {
    emit(const HomeState(status: HomeStatus.loading));
    try {
      final products = await _getProducts(offset: 0, limit: _pageSize);
      final categories = await _getCategories();
      emit(
        HomeState(
          status: HomeStatus.success,
          products: products,
          categories: categories,
          hasReachedMax: products.length < _pageSize,
        ),
      );
    } catch (e) {
      emit(
        HomeState(
          status: HomeStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.status != HomeStatus.success ||
        state.isLoadingMore ||
        state.hasReachedMax) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    try {
      final newProducts = await _getProducts(
        offset: state.products.length,
        limit: _pageSize,
      );
      emit(
        state.copyWith(
          products: [...state.products, ...newProducts],
          isLoadingMore: false,
          hasReachedMax: newProducts.length < _pageSize,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}