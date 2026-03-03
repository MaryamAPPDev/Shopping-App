import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import '../core/theme/app_theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final isInCart = cartProvider.isInCart(product.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => _navigateToDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Hero
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product_image_${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.mainImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppTheme.greyColor,
                        ),
                      ),
                    ),
                  ),
                  // Category Badge
                  if (product.category != null)
                    Positioned(
                      top: AppTheme.sm,
                      left: AppTheme.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.darkColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        child: Text(
                          product.category!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),

                    // Price and Cart Button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _buildCartButton(context, isInCart, cartProvider),
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

  Widget _buildCartButton(BuildContext context, bool isInCart, CartProvider cartProvider) {
    return Material(
      color: isInCart ? AppTheme.successColor : AppTheme.primaryColor,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: InkWell(
        onTap: () {
          if (isInCart) {
            cartProvider.removeFromCart(product.id);
          } else {
            cartProvider.addToCart(product);
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(
            isInCart ? Icons.check : Icons.add_shopping_cart,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }
}