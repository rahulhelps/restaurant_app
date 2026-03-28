import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../bloc/cart_bloc/cart_event.dart';
import '../../../bloc/cart_bloc/cart_state.dart';
import '../../../bloc/food_bloc/food_bloc.dart';
import '../../../bloc/food_bloc/food_state.dart';
import '../product/product_details_screen.dart';
import '../../../data/models/food_model.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String selectedCategory = "All";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Our Menu",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              /// SEARCH + FILTER ROW
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase().trim();
                          });
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Search menu...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// CATEGORY CHIPS
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _chip("All"),
                    _chip("Burger"),
                    _chip("Pizza"),
                    _chip("Biryani"),
                    _chip("Pasta"),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// BlocListener (একবারই) + Food Grid
              Expanded(
                child: BlocListener<CartBloc, CartState>(
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
                  child: BlocBuilder<FoodBloc, FoodState>(
                    builder: (context, state) {
                      if (state is FoodLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is FoodError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is FoodLoaded) {
                        var foods = state.foods;

                        // Category Filter
                        if (selectedCategory != "All") {
                          foods = foods
                              .where((f) => f.category == selectedCategory)
                              .toList();
                        }

                        // Search Filter
                        if (_searchQuery.isNotEmpty) {
                          foods = foods
                              .where(
                                (food) =>
                                    food.name.toLowerCase().contains(
                                      _searchQuery,
                                    ) ||
                                    food.description.toLowerCase().contains(
                                      _searchQuery,
                                    ) ||
                                    food.category.toLowerCase().contains(
                                      _searchQuery,
                                    ),
                              )
                              .toList();
                        }

                        if (foods.isEmpty) {
                          return const Center(child: Text("No items found"));
                        }

                        return GridView.builder(
                          itemCount: foods.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            final food = foods[index];
                            return _card(food);
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 CATEGORY CHIP
  Widget _chip(String text) {
    bool isSelected = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  /// 🔹 FOOD CARD (এখান থেকে BlocConsumer সরানো হয়েছে)
  Widget _card(FoodModel food) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailsScreen(food: food)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    food.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),

                /// ⭐ RATING
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.orange),
                        const SizedBox(width: 3),
                        const Text("4.9"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// TEXT SECTION
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "৳ ${food.price}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// Add to Cart Button
                      InkWell(
                        onTap: () {
                          context.read<CartBloc>().add(
                            AddToCartEvent(foodId: food.id, quantity: 1),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
