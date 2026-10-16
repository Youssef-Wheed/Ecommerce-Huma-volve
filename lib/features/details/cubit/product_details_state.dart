import '../../home/domain/entities/product_entity.dart';

enum ProductDetailsStatus { loading, success, failure }

class ProductDetailsState {
  final ProductDetailsStatus status;
  final ProductEntity? product;
  final String? errorMessage;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.loading,
    this.product,
    this.errorMessage,
  });
}