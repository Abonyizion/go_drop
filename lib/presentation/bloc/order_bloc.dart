import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../../data/repositories/order_repository.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<CreateOrderEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        // Create the order and get the created order ID
        final orderId = await repository.createOrder(event.order);

        // Emit success with the new order ID
        emit(OrderSuccess(orderId: orderId));
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });


    on<FetchUserOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await repository.fetchUserOrders();
        emit(OrderSuccess(orders: orders));
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });
  }
}
