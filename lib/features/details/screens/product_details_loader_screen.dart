import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dummy_data.dart';
import '../../../core/theme.dart';
import '../../home/data/datasources/home_remote_data_source.dart';
import '../../home/data/repo/home_repo_impl.dart';
import '../../home/domain/entities/product_entity.dart';
import '../../home/domain/usecases/get_product_by_id_usecase.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';
import 'product_details_screen.dart';

class ProductDetailsLoaderScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsLoaderScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repo = HomeRepoImpl(HomeRemoteDataSource());
        return ProductDetailsCubit(GetProductByIdUseCase(repo))
          ..load(productId);
      },
      child: _LoaderView(productId: productId),
    );
  }
}

class _LoaderView extends StatelessWidget {
  final int productId;

  const _LoaderView({required this.productId});

  static const String _fallbackImage =
      'https://placehold.co/600x600/png?text=Product';

  Product _toDetailsProduct(ProductEntity p) {
    return Product(
      id: p.id.toString(),
      name: p.title,
      description: p.description,
      price: p.price,
      imageUrl: p.images.isNotEmpty ? p.images.first : _fallbackImage,
      colors: [Colors.black, Colors.white, Colors.grey],
      sizes: ['S', 'M', 'L', 'XL'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state.status == ProductDetailsStatus.success &&
            state.product != null) {
          return ProductDetailsScreen(
            product: _toDetailsProduct(state.product!),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(backgroundColor: AppTheme.background, elevation: 0),
          body: Center(
            child: state.status == ProductDetailsStatus.failure
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.errorMessage ?? 'Something went wrong'),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context
                      .read<ProductDetailsCubit>()
                      .load(productId),
                  child: const Text('Retry'),
                ),
              ],
            )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}