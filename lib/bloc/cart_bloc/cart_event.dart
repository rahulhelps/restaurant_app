abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final String foodId;
  final int quantity;

  AddToCartEvent({
    required this.foodId,
    required this.quantity,
  });
}

class FetchCartEvent extends CartEvent {}

class UpdateCartQuantityEvent extends CartEvent {
  final String cartItemId;
  final int newQuantity;

  UpdateCartQuantityEvent({
    required this.cartItemId,
    required this.newQuantity,
  });
}

class DeleteCartItemEvent extends CartEvent {
  final String cartItemId;

  DeleteCartItemEvent({required this.cartItemId});
}





// abstract class CartEvent {}
//
// class AddToCart extends CartEvent {
//   final String name;
//   final double price;
//
//   AddToCart({required this.name, required this.price});
// }
//
// class IncreaseQuantity extends CartEvent {
//   final int index;
//   IncreaseQuantity(this.index);
// }
//
// class DecreaseQuantity extends CartEvent {
//   final int index;
//   DecreaseQuantity(this.index);
// }
//
// class RemoveItem extends CartEvent {
//   final int index;
//   RemoveItem(this.index);
// }
//
// class AddToCartEvent extends CartEvent {
//   final int quantity;
//   final String userId;
//   final String foodId;
//
//   AddToCartEvent(this.userId, this.foodId, this.quantity);
// }
//
// class GetCartEvent extends CartEvent {
//
// }
//
//
// class UpdateCartEvent extends CartEvent {
//   final String cartId;
//   final int quantity;
//   final String userId;
//
//   UpdateCartEvent({
//     required this.cartId,
//     required this.quantity,
//     required this.userId,
//   });
// }
//
// class RemoveCartEvent extends CartEvent {
//   final String cartId;
//   final String userId;
//
//   RemoveCartEvent({
//     required this.cartId,
//     required this.userId,
//   });
// }