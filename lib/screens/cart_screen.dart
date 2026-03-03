import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return _buildEmptyCart(context);
          }

          final items = cart.uniqueItems;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.md),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final quantity = cart.getQuantity(item.id);

                    return Card(
                      margin: const EdgeInsets.only(bottom: AppTheme.md),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.sm),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              child: CachedNetworkImage(
                                imageUrl: item.mainImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: AppTheme.xs),
                                  Text(
                                    '\$${(item.price * quantity).toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: AppTheme.xs),
                                  // Quantity Controls
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () {
                                          cart.decreaseQuantity(item.id);
                                        },
                                      ),
                                      Text(
                                        '$quantity',
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () {
                                          cart.increaseQuantity(item);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppTheme.errorColor,
                              ),
                              onPressed: () {
                                cart.removeAllOfProduct(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildCheckoutSection(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: AppTheme.lg),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            'Add items to get started',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.xl),
          CustomButton(
            text: 'Continue Shopping',
            icon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${cart.itemCount} items)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  cart.formattedTotalPrice,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: AppTheme.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  cart.formattedTotalPrice,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.lg),
            CustomButton(
              text: 'Checkout',
              icon: Icons.payment,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Checkout'),
                    content: Text(
                      'Total amount: ${cart.formattedTotalPrice}\n\nThis is a demo app. No actual payment will be processed.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      CustomButton(
                        text: 'Confirm',
                        onPressed: () {
                          cart.clearCart();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order placed successfully!'),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
