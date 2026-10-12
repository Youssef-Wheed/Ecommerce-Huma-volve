import 'package:dio/dio.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repos/home_repo.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remote;

  HomeRepoImpl(this._remote);

  @override
  Future<List<ProductEntity>> getProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      return await _remote.getProducts(offset: offset, limit: limit);
    } on DioException {
      throw Exception('Something went wrong, check your internet');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      return await _remote.getCategories();
    } on DioException {
      throw Exception('Something went wrong, check your internet');
    }
  }
}