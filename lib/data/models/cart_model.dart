class CartResponse {
  final List<dynamic> items;     // Backend থেকে আসা raw items
  final int totalPrice;

  CartResponse({required this.items, required this.totalPrice});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      items: json['items'] ?? [],
      totalPrice: json['totalPrice'] ?? 0,
    );
  }
}