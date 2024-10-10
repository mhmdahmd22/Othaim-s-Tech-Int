/// * The product identifier is an important concept and can have its own type.
typedef ProductID = String;

/// Class representing a product.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
  });

  /// Unique product id
  final ProductID id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String image;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      price: map['price'].toDouble(),
      image: map['image'],
      category: map['category'],
    );
  }

  /// Factory constructor to create a Product from a JSON object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(), // Ensures ID is always a string
      title: json['title'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category'],
      description: json['description'],
      image: json['image'],
    );
  }

  /// Convert a Product instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price.toString(),
      'category': category,
      'description': description,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, category: $category, description: $description, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.image == image &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        category.hashCode;
  }

  Product copyWith({
    ProductID? id,
    String? image,
    String? title,
    String? description,
    double? price,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }
}
