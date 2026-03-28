
class OrderModel {
  final String id;
  final String? restaurantName;
  final List<OrderItem> items;
  final double totalPrice;
  final String status;
  final String? paymentMethod;
  final String? name;
  final String? transactionId;
  final String createdAt;

  OrderModel({
    required this.id,
    this.restaurantName,
    required this.items,
    required this.totalPrice,
    required this.status,
    this.paymentMethod,
    this.name,
    this.transactionId,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      restaurantName: json['restaurantName'],
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class OrderItem {
  final String? name;
  final double? price;
  final String? image;
  final int quantity;

  OrderItem({
    this.name,
    this.price,
    this.image,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'],
      quantity: json['quantity'] ?? 1,
    );
  }
}