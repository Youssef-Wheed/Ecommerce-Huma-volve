import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dummy_data.dart';
import '../../../../core/theme.dart';

import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repo/home_repo_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repo = HomeRepoImpl(HomeRemoteDataSource());

        return HomeCubit(GetProductsUseCase(repo), GetCategoriesUseCase(repo))
          ..loadHome();
      },
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  Widget _buildBody(
      BuildContext context,
      HomeState state,
      List<ProductEntity> products,
      ) {
    if (state.status == HomeStatus.failure) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Text(state.errorMessage ?? 'Something went wrong'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.read<HomeCubit>().loadHome(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.status != HomeStatus.success) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (products.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Center(child: Text('No products found')),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return ProductCard(product: products[index]);
        }, childCount: products.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final categoryNames = [
              'All',
              ...state.categories.map((c) => c.name),
            ];

            var products = state.products;

            if (_selectedCategoryIndex > 0 &&
                _selectedCategoryIndex <= state.categories.length) {
              final selectedId =
                  state.categories[_selectedCategoryIndex - 1].id;

              products = products
                  .where((p) => p.category.id == selectedId)
                  .toList();
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.menu,
                                color: AppTheme.primary,
                              ),
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                dummyUser.profilePictureUrl,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Explore',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(fontSize: 36),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Best trendy collection!',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search clothes...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              suffixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (state.status == HomeStatus.success) ...[
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryNames.length,
                              separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                return CategoryChip(
                                  label: categoryNames[index],
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryIndex = index;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                _buildBody(context, state, products),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: state.isLoadingMore
                          ? const CircularProgressIndicator()
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}