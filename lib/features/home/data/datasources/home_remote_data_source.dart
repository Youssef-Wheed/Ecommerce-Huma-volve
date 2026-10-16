import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeRemoteDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<ProductModel>> getProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      ApiConstants.products,
      queryParameters: {'offset': offset, 'limit': limit},
    );
    return (response.data as List)
        .map((item) => ProductModel.fromJson(item))
        .toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get(ApiConstants.categories);
    return (response.data as List)
        .map((item) => CategoryModel.fromJson(item))
        .toList();
  }
  Future<ProductModel> getProductById(int id) async {
    final response = await _dio.get('${ApiConstants.products}/$id');
    return ProductModel.fromJson(response.data);
  }

}