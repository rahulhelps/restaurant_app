import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../bloc/cart_bloc/cart_event.dart';
import '../../../bloc/cart_bloc/cart_state.dart';
import '../../../data/models/food_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final FoodModel food;

  const ProductDetailsScreen({super.key, required this.food});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          /// 🔥 IMAGE SECTION (একদম আগের মতো)
          Stack(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  widget.food.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),

              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: _circleIcon(Icons.arrow_back),
                    ),
                    _circleIcon(Icons.favorite_border),
                  ],
                ),
              ),

              Positioned(
                bottom: 10,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 5),
                      const Text('4.9'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// 🔥 BODY (SCROLLABLE) - একদম আগের মতো
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.food.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "৳ ${widget.food.price}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      widget.food.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Beef, Garlic, Butter, Herbs",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Cooking Time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "25 - 30 mins",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      /// 🔥 BOTTOM BAR - Professional Add to Cart with Bloc
      bottomNavigationBar: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartAddedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is CartLoading;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                /// Quantity Selector
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => quantity++);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                /// ADD TO CART BUTTON
                Expanded(
                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () {
                            final foodId = widget.food.id;

                            context.read<CartBloc>().add(
                              AddToCartEvent(
                                foodId: foodId,
                                quantity: quantity,
                              ),
                            );
                          },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: isLoading
                            ? Colors.grey
                            : const Color(0xFF1B5E20),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Add to Cart   ৳ ${widget.food.price * quantity}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Circle Icon
  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon),
    );
  }
}
