import 'package:flutter/material.dart';
import '../../../../core/dummy_data.dart';
import '../../../../core/theme.dart';
import '../../../details/screens/product_details_screen.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  const ProductCard({super.key, required this.product});

  String get _imageUrl =>
      product.images.isNotEmpty ? product.images.first : '';

  Product _toDetailsProduct() {
    return Product(
      id: product.id.toString(),
      name: product.title,
      description: product.description,
      price: product.price,
      imageUrl: _imageUrl,
      colors: [Colors.black, Colors.white, Colors.grey],
      sizes: ['S', 'M', 'L', 'XL'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey.shade400,
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductDetailsScreen(product: _toDetailsProduct()),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: _imageUrl.isEmpty
                            ? placeholder
                            : Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          placeholder,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}