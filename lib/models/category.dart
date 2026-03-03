class Category {
  final int id;
  final String name;
  final String image;
  final DateTime? creationAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.creationAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      image: json['image'] ?? '',
      creationAt: json['creationAt'] != null
          ? DateTime.tryParse(json['creationAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'creationAt': creationAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Category &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}