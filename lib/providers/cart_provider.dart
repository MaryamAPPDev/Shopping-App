import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];

  /// All items in cart (including duplicates)
  List<Product> get cartItems => List.unmodifiable(_cartItems);

  /// Total items count (including duplicates)
  int get itemCount => _cartItems.length;

  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;

  /// Total price considering quantity
  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.price);

  String get formattedTotalPrice {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(totalPrice);
  }

  /// Add product to cart (increase quantity if already exists)
  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  /// Decrease quantity by 1. If only 1, remove completely.
  void removeFromCart(int productId) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  /// Remove all quantities of a product
  void removeAllOfProduct(int productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  /// Clear entire cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  /// Check if a product exists in cart
  bool isInCart(int productId) {
    return _cartItems.any((item) => item.id == productId);
  }

  /// Quantity of a specific product
  int getQuantity(int productId) =>
      _cartItems.where((item) => item.id == productId).length;

  /// Unique products list (for UI)
  List<Product> get uniqueItems {
    final Map<int, Product> map = {};
    for (var item in _cartItems) {
      map[item.id] = item;
    }
    return map.values.toList();
  }

  /// Increase quantity of product
  void increaseQuantity(Product product) {
    addToCart(product);
  }

  /// Decrease quantity of product
  void decreaseQuantity(int productId) {
    removeFromCart(productId);
  }
}
