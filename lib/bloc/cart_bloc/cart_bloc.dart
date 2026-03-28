import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../data/services/cart_service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<FetchCartEvent>(fetchCartEvent);
    on<UpdateCartQuantityEvent>(updateCartQuantityEvent);
    on<DeleteCartItemEvent>(deleteCartItemEvent);
  }

  Future<void> _onAddToCart(
      AddToCartEvent event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());

    try {
      final success = await CartService.addToCart(
        foodId: event.foodId,
        quantity: event.quantity,
      );

      if (success) {
        emit(CartAddedSuccess("${event.quantity} x item added to cart! 🎉"));

        // 🔥 এই লাইনটা যোগ করো — সবচেয়ে গুরুত্বপূর্ণ
        // Add করার পরপরই Cart আবার লোড করবে
        Future.delayed(const Duration(milliseconds: 300), () {
          add(FetchCartEvent());
        });
      } else {
        emit(CartError("Failed to add item to cart"));
      }
    } catch (e) {
      emit(CartError("Something went wrong. Please check your connection."));
    }
  }

  FutureOr<void> fetchCartEvent(
    FetchCartEvent event,
    Emitter<CartState> emit,
  ) async {
    // emit(CartLoading());
    try {
      final cartResponse = await CartService.getCart();

      if (cartResponse == null) {
        emit(CartError("Failed to load cart"));
        return;
      }

      if (cartResponse.items.isEmpty) {
        emit(CartEmpty());                    // ← Empty State
      } else {
        emit(CartLoaded(
          items: cartResponse.items,
          totalPrice: cartResponse.totalPrice,
        ));
      }
    } catch (e) {
      emit(CartError("Something went wrong"));
    }
  }

  FutureOr<void> updateCartQuantityEvent(
    UpdateCartQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    // Optional: শুধু loading indicator দেখাতে চাইলে
    // emit(CartQuantityUpdating());

    try {
      final success = await CartService.updateCartQuantity(
        cartItemId: event.cartItemId,
        quantity: event.newQuantity,
      );

      if (success) {
        add(FetchCartEvent());
      } else {
        emit(CartError("Failed to update quantity"));
      }
    } catch (e) {
      emit(CartError("Something went wrong while updating quantity"));
    }
  }

  FutureOr<void> deleteCartItemEvent(
    DeleteCartItemEvent event,
    Emitter<CartState> emit,
  ) async{
    try {
      final success = await CartService.deleteCartItem(event.cartItemId);

      if (success) {
        // Delete সফল হলে আবার পুরো Cart Reload করবো
        add(FetchCartEvent());
      } else {
        emit(CartError("Failed to delete item"));
      }
    } catch (e) {
      emit(CartError("Something went wrong while deleting item"));
    }
  }
}
