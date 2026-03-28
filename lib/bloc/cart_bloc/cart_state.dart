abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<dynamic> items;        // Backend থেকে আসা items array
  final int totalPrice;

  CartLoaded({required this.items, required this.totalPrice});
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartAddedSuccess extends CartState {
  final String message;
  CartAddedSuccess(this.message);
}

class CartQuantityUpdating extends CartState {}   // Loading for specific item

class CartEmpty extends CartState {}


// abstract class CartState {}
//
// class CartInitial extends CartState {}
//
// class CartLoading extends CartState {}
//
// class CartSuccess extends CartState {
//   final List items;
//   final double totalPrice;
//
//   CartSuccess({
//     required this.items,
//     required this.totalPrice,
//   });
// }
//
// class CartError extends CartState {}