import 'package:flutter/material.dart';

class CartItemCards extends StatelessWidget {
  final String name;
  final int price;
  final int quantity;
  final String imageUrl;

  final VoidCallback onDelete;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemCards({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.onDelete,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = price * quantity;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(color: Colors.black)
      ),
      child: Row(
        children: [
          /// 🍗 IMAGE (Network)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image, size: 50),
            ),
          ),

          const SizedBox(width: 10),

          /// 📦 INFO SECTION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE + DELETE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                /// PRICE
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.green),
                ),

                const SizedBox(height: 6),

                /// QUANTITY CONTROLLER
                Row(
                  children: [
                    _qtyButton(icon: Icons.remove, onTap: onDecrease),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _qtyButton(icon: Icons.add, onTap: onIncrease),

                    const Spacer(),

                    /// TOTAL PRICE
                    Text(
                      "\$${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
