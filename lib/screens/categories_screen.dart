import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/category.dart';
import '../../providers/product_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/product_card.dart';
import '../../widgets/custom_button.dart';

class CategoriesScreen extends StatefulWidget {
  final Category? initialCategory;

  const CategoriesScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      provider.fetchCategories();
      if (widget.initialCategory != null) {
        provider.fetchProductsByCategory(widget.initialCategory!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // Check if we're showing products for a category
        final isShowingProducts = widget.initialCategory != null ||
            provider.selectedCategory != null;

        return Scaffold(
          // Hide AppBar when showing products, show only when browsing categories
          appBar: isShowingProducts ? null : AppBar(
            title: const Text('Categories'),
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(ProductProvider provider) {
    if (provider.isCategoriesLoading && provider.categories.isEmpty) {
      return const LoadingWidget(message: 'Loading categories...');
    }

    if (provider.categoriesError != null && provider.categories.isEmpty) {
      return _buildErrorWidget(provider.categoriesError!);
    }

    if (widget.initialCategory != null || provider.selectedCategory != null) {
      return _buildCategoryProducts(provider);
    }

    return _buildCategoriesGrid(provider);
  }

  Widget _buildCategoriesGrid(ProductProvider provider) {
    if (provider.categories.isEmpty) {
      return const Center(
        child: Text('No categories available'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppTheme.md,
        mainAxisSpacing: AppTheme.md,
      ),
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final category = provider.categories[index];
        return _CategoryCard(
          category: category,
          onTap: () => provider.fetchProductsByCategory(category),
        );
      },
    );
  }

  Widget _buildCategoryProducts(ProductProvider provider) {
    final category = provider.selectedCategory ?? widget.initialCategory;

    return Column(
      children: [
        // Custom header bar instead of AppBar
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + AppTheme.sm, // Status bar height
            left: AppTheme.sm,
            right: AppTheme.md,
            bottom: AppTheme.md,
          ),
          color: AppTheme.primaryColor.withOpacity(0.1),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (provider.selectedCategory != null) {
                    provider.clearCategorySelection();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              Expanded(
                child: Text(
                  category?.name ?? 'Products',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildProductsList(provider),
        ),
      ],
    );
  }

  Widget _buildProductsList(ProductProvider provider) {
    if (provider.isCategoryProductsLoading) {
      return const LoadingWidget(message: 'Loading products...');
    }

    if (provider.categoryProductsError != null) {
      return _buildErrorWidget(
        provider.categoryProductsError!,
        onRetry: () {
          if (provider.selectedCategory != null) {
            provider.fetchProductsByCategory(provider.selectedCategory!);
          }
        },
      );
    }

    if (provider.categoryProducts.isEmpty) {
      return const Center(
        child: Text('No products in this category'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppTheme.md,
        mainAxisSpacing: AppTheme.md,
      ),
      itemCount: provider.categoryProducts.length,
      itemBuilder: (context, index) {
        final product = provider.categoryProducts[index];
        return ProductCard(product: product);
      },
    );
  }

  Widget _buildErrorWidget(String error, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: AppTheme.md),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.lg),
              CustomButton(
                text: 'Retry',
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: category.image,
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: AppTheme.md,
              left: AppTheme.md,
              right: AppTheme.md,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}