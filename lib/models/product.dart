import 'category.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final DateTime? creationAt;
  final DateTime? updatedAt;
  final Category? category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.creationAt,
    this.updatedAt,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? 'No description available',
      images: _parseImages(json['images']),
      creationAt: json['creationAt'] != null
          ? DateTime.tryParse(json['creationAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
    );
  }

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];
    if (images is List) {
      return images
          .map((e) => e.toString())
          .where((url) => url.isNotEmpty && url.startsWith('http'))
          .toList();
    }
    return [];
  }

  String get mainImage => images.isNotEmpty ? images.first : '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'images': images,
      'creationAt': creationAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'category': category?.toJson(),
    };
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    List<String>? images,
    DateTime? creationAt,
    DateTime? updatedAt,
    Category? category,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      creationAt: creationAt ?? this.creationAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}