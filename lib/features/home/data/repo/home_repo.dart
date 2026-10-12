import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';


class HomeRepo {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<ProductModel>> getProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.products,
        queryParameters: {'offset': offset, 'limit': limit},
      );
      return (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } on DioException {
      throw Exception('Something went wrong, check your internet');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categories);
      return (response.data as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    } on DioException {
      throw Exception('Something went wrong, check your internet');
    }
  }
}