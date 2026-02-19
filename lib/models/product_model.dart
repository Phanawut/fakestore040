class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description; // เพิ่ม description
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      description: json['description'] ?? '', // ดึงข้อมูล description จาก API
      image: json['image'] ?? '',
    );
  }
}