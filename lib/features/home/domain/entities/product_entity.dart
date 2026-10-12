import 'category_entity.dart';

class ProductEntity {
  final int id;
  final String title;
  final double price;
  final String description;
  final CategoryEntity category;
  final List<String> images;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });
}