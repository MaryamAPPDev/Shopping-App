import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/categories_screen.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/custom_button.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  Future<void> _refreshProducts() async {
    await context.read<ProductProvider>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          _buildCartButton(),
          const SizedBox(width: AppTheme.sm),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: _buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCartButton() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            if (cart.isNotEmpty)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.md),
      child: Row(
        children: [
          ActionChip(
            avatar: const Icon(Icons.category, size: 18),
            label: const Text('Categories'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CategoriesScreen()),
              );
            },
          ),
          const VerticalDivider(
            width: AppTheme.lg,
            indent: AppTheme.md,
            endIndent: AppTheme.md,
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.categories.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: AppTheme.sm),
                      child: ActionChip(
                        label: Text(category.name),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CategoriesScreen(
                                initialCategory: category,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isProductsLoading && provider.products.isEmpty) {
          return const LoadingWidget(message: 'Loading products...');
        }

        if (provider.productsError != null && provider.products.isEmpty) {
          return _buildErrorWidget(provider.productsError!);
        }

        if (provider.products.isEmpty) {
          return _buildEmptyWidget();
        }

        return RefreshIndicator(
          onRefresh: _refreshProducts,
          child: GridView.builder(
            padding: const EdgeInsets.all(AppTheme.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: AppTheme.md,
              mainAxisSpacing: AppTheme.md,
            ),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return ProductCard(product: product);
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
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
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.lg),
            CustomButton(
              text: 'Retry',
              icon: Icons.refresh,
              onPressed: _refreshProducts,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppTheme.lightGreyColor,
          ),
          const SizedBox(height: AppTheme.md),
          Text(
            'No products available',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            'Check back later for new arrivals',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}