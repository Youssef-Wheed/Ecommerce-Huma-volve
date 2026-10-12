import '../../domain/entities/product_entity.dart';
import 'category_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: CategoryModel.fromJson(json['category']),
      images: (json['images'] as List)
          .map((e) => e.toString().replaceAll(RegExp(r'[\[\]"]'), ''))
          .toList(),
    );
  }
}
