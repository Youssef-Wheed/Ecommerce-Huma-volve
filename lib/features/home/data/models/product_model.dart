import 'category_model.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final CategoryModel category;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
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