import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/data/services/order_service.dart';

import 'order_history_state.dart';
part 'order_history_event.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderService orderService;

  OrderHistoryBloc(this.orderService) : super(OrderHistoryInitial()) {
    on<FetchOrderHistory>(_onFetchOrderHistory);
  }

  Future<void> _onFetchOrderHistory(
      FetchOrderHistory event, Emitter<OrderHistoryState> emit) async {
    emit(OrderHistoryLoading());

    try {
      final orders = await orderService.getUserOrders();   // ← এটা OrderService এর হতে হবে
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderHistoryError(e.toString()));
    }
  }
}