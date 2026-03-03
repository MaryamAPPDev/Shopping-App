import 'package:flutter/foundation.dart' hide Category;
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';

enum LoadingState { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Product> _products = [];
  List<Product> _categoryProducts = [];
  List<Category> _categories = [];
  LoadingState _productsState = LoadingState.initial;
  LoadingState _categoriesState = LoadingState.initial;
  LoadingState _categoryProductsState = LoadingState.initial;
  String? _productsError;
  String? _categoriesError;
  String? _categoryProductsError;
  Category? _selectedCategory;

  ProductProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // Getters
  List<Product> get products => List.unmodifiable(_products);
  List<Product> get categoryProducts => List.unmodifiable(_categoryProducts);
  List<Category> get categories => List.unmodifiable(_categories);
  LoadingState get productsState => _productsState;
  LoadingState get categoriesState => _categoriesState;
  LoadingState get categoryProductsState => _categoryProductsState;
  String? get productsError => _productsError;
  String? get categoriesError => _categoriesError;
  String? get categoryProductsError => _categoryProductsError;
  Category? get selectedCategory => _selectedCategory;

  bool get isProductsLoading => _productsState == LoadingState.loading;
  bool get isCategoriesLoading => _categoriesState == LoadingState.loading;
  bool get isCategoryProductsLoading => _categoryProductsState == LoadingState.loading;

  Future<void> fetchProducts() async {
    if (_productsState == LoadingState.loading) return;

    _productsState = LoadingState.loading;
    _productsError = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
      _productsState = LoadingState.loaded;
    } on Exception catch (e) {
      _productsError = e.toString().replaceFirst('Exception: ', '');
      _productsState = LoadingState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    if (_categoriesState == LoadingState.loading) return;

    _categoriesState = LoadingState.loading;
    _categoriesError = null;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
      _categoriesState = LoadingState.loaded;
    } on Exception catch (e) {
      _categoriesError = e.toString().replaceFirst('Exception: ', '');
      _categoriesState = LoadingState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(Category category) async {
    if (_categoryProductsState == LoadingState.loading) return;

    _selectedCategory = category;
    _categoryProductsState = LoadingState.loading;
    _categoryProductsError = null;
    notifyListeners();

    try {
      _categoryProducts = await _apiService.getProductsByCategory(category.id);
      _categoryProductsState = LoadingState.loaded;
    } on Exception catch (e) {
      _categoryProductsError = e.toString().replaceFirst('Exception: ', '');
      _categoryProductsState = LoadingState.error;
    } finally {
      notifyListeners();
    }
  }

  void clearCategorySelection() {
    _selectedCategory = null;
    _categoryProducts = [];
    _categoryProductsState = LoadingState.initial;
    notifyListeners();
  }

  void clearErrors() {
    _productsError = null;
    _categoriesError = null;
    _categoryProductsError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}