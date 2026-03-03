import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/product.dart';
import '../models/category.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> getProducts() async {
    return _handleRequest(
      uri: Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}'),
      parser: (data) {
        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        }
        throw ApiException('Invalid response format for products');
      },
    );
  }

  Future<Product> getProductById(int id) async {
    return _handleRequest(
      uri: Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productById(id)}'),
      parser: (data) => Product.fromJson(data),
    );
  }

  Future<List<Category>> getCategories() async {
    return _handleRequest(
      uri: Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}'),
      parser: (data) {
        if (data is List) {
          return data.map((json) => Category.fromJson(json)).toList();
        }
        throw ApiException('Invalid response format for categories');
      },
    );
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    return _handleRequest(
      uri: Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsByCategory(categoryId)}'),
      parser: (data) {
        if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        }
        throw ApiException('Invalid response format for category products');
      },
    );
  }

  Future<T> _handleRequest<T>({
    required Uri uri,
    required T Function(dynamic) parser,
  }) async {
    try {
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return parser(decodedData);
      } else if (response.statusCode >= 500) {
        throw ApiException(
          'Server error. Please try again later.',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 404) {
        throw ApiException(
          'Resource not found.',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          'Failed to load data. Status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (_) {
      throw NetworkException('No internet connection. Please check your network.');
    } on FormatException catch (_) {
      throw ApiException('Invalid data format received from server.');
    } on HttpException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}