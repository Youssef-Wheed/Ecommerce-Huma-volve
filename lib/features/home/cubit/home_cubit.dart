import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _repo;

  HomeCubit(this._repo) : super(const HomeState());

  Future<void> loadHome() async {
    emit(const HomeState(status: HomeStatus.loading));
    try {
      final products = await _repo.getProducts(limit: 30);
      final categories = await _repo.getCategories();
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