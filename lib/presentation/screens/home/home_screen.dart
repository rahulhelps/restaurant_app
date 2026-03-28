import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/presentation/screens/product/product_details_screen.dart';
import '../../../bloc/food_bloc/food_bloc.dart';
import '../../../bloc/food_bloc/food_event.dart';
import '../../../bloc/food_bloc/food_state.dart';
import '../../../data/models/food_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(FetchFoodsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER (আগের মতো)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ready to order?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.notifications_none),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔍 SEARCH BAR (এখন কার্যকর)
              Container(
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
                    hintText: "Search for dishes...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _promoCard(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.yellow,
                    duration: Duration(milliseconds: 800),
                    content: Text(
                      'Please go to menu section...!',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              /// FEATURED TITLE
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Dishes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("See All", style: TextStyle(color: Colors.orange)),
                ],
              ),

              const SizedBox(height: 10),

              /// LIST WITH SEARCH FILTER
              Expanded(
                child: BlocBuilder<FoodBloc, FoodState>(
                  builder: (context, state) {
                    if (state is FoodLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FoodError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${state.message}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<FoodBloc>().add(
                                FetchFoodsEvent(),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is FoodLoaded) {
                      // Search Filter Logic
                      final filteredFoods = _searchQuery.isEmpty
                          ? state.foods
                          : state.foods
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

                      if (filteredFoods.isEmpty) {
                        return const Center(
                          child: Text('No matching dishes found'),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredFoods.length,
                        itemBuilder: (context, index) {
                          final food = filteredFoods[index];
                          return _foodCard(food);
                        },
                      );
                    }

                    return const Center(child: Text("Error loading data"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Promo Card
  Widget _promoCard(void Function()? onTap) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3A6B4E), Color(0xFF4E8B65)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Limited Time", style: TextStyle(fontSize: 12)),
          ),
          SizedBox(height: 10),
          Text(
            "30% OFF",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "On your first order this week!",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("Order Now"),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Category Chip
  Widget _chip(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: selected ? Colors.orange : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }

  /// 🔹 Food Card
  // ✅ Improved _foodCard (এখন পুরো FoodModel পাস করা হয়েছে)
  Widget _foodCard(FoodModel food) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailsScreen(food: food)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                food.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    food.category,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "৳ ${food.price}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Column(
              children: [
                Icon(Icons.star, color: Colors.orange),
                Text("4.9"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
