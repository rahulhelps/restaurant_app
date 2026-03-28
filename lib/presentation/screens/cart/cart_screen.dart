import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quick_payment/core/_controller.dart';
import 'package:quick_payment/models/credentials_model.dart';
import 'package:quick_payment/models/customer_model.dart';
import 'package:quick_payment/models/payment_method.dart';
import 'package:restaurant_app/core/utils/token_storage.dart';
import 'package:restaurant_app/presentation/screens/nav/nav_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../bloc/cart_bloc/cart_event.dart';
import '../../../bloc/cart_bloc/cart_state.dart';
import '../../shared widgets/CartItemCard.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFAF8F3),
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
      ),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          // 1. Loading
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error
          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 70, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<CartBloc>().add(FetchCartEvent()),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // 3. Empty Cart
          if (state is CartEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 90,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Your Cart is Empty",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Start adding some delicious food!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 4. Cart Loaded (Items আছে)
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text("Your cart is empty"));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];

            

                      return CartItemCards(
                        name: item["name"].toString() ?? "Unknown Item",
                        price: (item["price"] ?? 0),
                        quantity: item["quantity"] ?? 1,
                        imageUrl:
                            item['image'] ??
                            'https://i.pinimg.com/736x/ad/6f/e3/ad6fe3cedd8b5338374586654b6abb59.jpg',

                        // 🔥 Network Image
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Remove?"),
                              content: const Text(
                                "Do you want to remove this item?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    context.read<CartBloc>().add(
                                      DeleteCartItemEvent(
                                        cartItemId: item["_id"],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Remove",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                        onDecrease: () {
                          final qty = item["quantity"] ?? 1;
                          if (qty > 1) {
                            context.read<CartBloc>().add(
                              UpdateCartQuantityEvent(
                                cartItemId: item["_id"],
                                newQuantity: qty - 1,
                              ),
                            );
                          }
                        },

                        onIncrease: () {
                          final qty = item["quantity"] ?? 1;
                          context.read<CartBloc>().add(
                            UpdateCartQuantityEvent(
                              cartItemId: item["_id"],
                              newQuantity: qty + 1,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // ================== TOTAL + CONFIRM BUTTON (Design 2 - Premium) ==================
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 25,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "৳ ${state.totalPrice}",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "VAT Included",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final name = prefs.getString("name") ?? "No Name";
                              final email =
                                  prefs.getString("email") ?? "No Email";
                              final token = prefs.getString("token");
                              final userId =
                                  prefs.getString("userId") ??
                                  TokenStorage.getUserId(); // তোমার userId যেভাবে সেভ করা আছে

                              if (token == null || userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please login first"),
                                  ),
                                );
                                return;
                              }

                              final cartState = context.read<CartBloc>().state;
                              if (cartState is! CartLoaded ||
                                  cartState.items.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Cart is empty!"),
                                  ),
                                );
                                return;
                              }

                              final customer = CustomerDetails(
                                fullName: name,
                                email: email,
                              );

                              final credentials = QuickPayCredentials(
                                methods: [
                                  PaymentMethod.bkash("01889663816"),
                                  PaymentMethod.nagad("01889663816"),
                                  PaymentMethod.rocket("01889663816"),
                                ],
                              );

                              QuickPay.createPayment(
                                context: context,
                                amount: cartState.totalPrice.toInt(),
                                customer: customer,
                                credentials: credentials,
                                onPaymentSubmitted: (data) async {
                                  print("🔥 Payment Data: ${data.toMap()}");

                                  try {
                                    // ✅ সঠিকভাবে foodId নেওয়া
                                    List<Map<String, dynamic>> orderItems =
                                        cartState.items.map((item) {
                                          // foodId কে সেফলি extract করো
                                          dynamic foodId = item["foodId"];
                                          if (foodId is Map) {
                                            foodId = foodId["_id"] ?? foodId;
                                          }

                                          return {
                                            "foodId": foodId.toString(),
                                            // String হিসেবে পাঠানো ভালো
                                            "quantity": item["quantity"] ?? 1,
                                          };
                                        }).toList();

                                    final response = await http.post(
                                      Uri.parse(
                                        'http://10.0.2.2:2000/api/orders/place',
                                      ),
                                      headers: {
                                        'Content-Type': 'application/json',
                                        'Authorization': 'Bearer $token',
                                      },
                                      body: jsonEncode({
                                        "userId": userId,
                                        "items": orderItems,
                                        "totalPrice": cartState.totalPrice,
                                        "paymentMethod":
                                            (data.method.toString()),
                                        "transactionId": data.transactionId,
                                        "paymentStatus": "Paid",
                                      }),
                                    );

                                    print(
                                      "📨 Order Response: ${response.body}",
                                    );

                                    if (response.statusCode == 201 ||
                                        response.statusCode == 200) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Order placed successfully! 🎉",
                                          ),
                                        ),
                                      );

                                      context.read<CartBloc>().add(
                                        FetchCartEvent(),
                                      );

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const NavScreen(),
                                        ),
                                      );
                                    } else {
                                      final errorBody = jsonDecode(
                                        response.body,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Order failed: ${errorBody['message'] ?? response.statusCode}",
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e, stack) {
                                    print("❌ Order Place Error: $e");
                                    print("Stack: $stack");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Something went wrong: $e",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Proceed to Checkout",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Default / Initial State
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
