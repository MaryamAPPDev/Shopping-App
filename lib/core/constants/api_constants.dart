class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  static const String products = '/products';
  static const String categories = '/categories';

  static String productById(int id) => '$products/$id';
  static String productsByCategory(int categoryId) => '$categories/$categoryId/products';
}