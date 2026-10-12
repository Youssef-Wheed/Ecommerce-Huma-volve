import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;

  HomeCubit(this._getProducts, this._getCategories)
      : super(const HomeState());

  Future<void> loadHome() async {
    emit(const HomeState(status: HomeStatus.loading));
    try {
      final products = await _getProducts(limit: 30);
      final categories = await _getCategories();
      emit(
        HomeState(
          status: HomeStatus.success,
          products: products,
          categories: categories,
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
}