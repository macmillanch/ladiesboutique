class Product {
  final String id;
  final String name;
  final double price;
  final double discount;
  final List<String> sizes;
  final List<String> colors;
  final List<String> images;
  final String description;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discount = 0.0,
    required this.sizes,
    required this.colors,
    required this.images,
    required this.description,
    this.isAvailable = true,
  });

  double get discountedPrice => price - (price * discount / 100);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discount': discount,
      'sizes': sizes,
      'colors': colors,
      'images': images,
      'description': description,
      'isAvailable': isAvailable,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      images: List<String>.from(
        json['image_urls'] ?? [],
      ), // Adjusted key based on backend
      description: json['description'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
