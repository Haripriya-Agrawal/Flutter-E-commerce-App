class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category; // 👈 Add this
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category, // 👈 Add this
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'], // 👈 Add this
      image: json['image'],
    );
  }
}
