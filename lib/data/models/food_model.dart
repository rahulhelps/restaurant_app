// class FoodModel {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final String image;
//   final String category;
//
//   FoodModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.image,
//     required this.category,
//   });
//
//   factory FoodModel.fromJson(Map<String, dynamic> json) {
//     return FoodModel(
//       id: json['_id'],
//       name: json['name'],
//       description: json['description'],
//       price: (json['price'] as num).toDouble(),
//       // 🔥 SAFE
//       image: json['image'],
//       category: json['category'],
//     );
//   }
//
//   operator [](String other) {}
// }


class FoodModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String image;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
