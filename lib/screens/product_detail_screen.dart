import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: AppTheme.md),
                      _buildDescription(context),
                      const SizedBox(height: AppTheme.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product_image_${product.id}',
          child: CachedNetworkImage(
            imageUrl: product.mainImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    if (product.images.length <= 1) return const SizedBox.shrink();

    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: AppTheme.md),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.md),
        itemCount: product.images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: AppTheme.sm),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.lightGreyColor),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              image: DecorationImage(
                image: CachedNetworkImageProvider(product.images[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.category != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Text(
              product.category!.name,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(height: AppTheme.sm),
        Text(
          product.title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppTheme.sm),
        Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'In Stock',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.sm),
        Text(
          product.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: AppTheme.greyColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final isInCart = cart.isInCart(product.id);

        return Container(
          padding: const EdgeInsets.all(AppTheme.md),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: CustomButton(
                    text: isInCart ? 'Remove from Cart' : 'Add to Cart',
                    icon: isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                    backgroundColor: isInCart ? AppTheme.errorColor : null,
                    onPressed: () {
                      if (isInCart) {
                        cart.removeFromCart(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        cart.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}