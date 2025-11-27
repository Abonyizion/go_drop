import '../../data/models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final String? orderId; // optional for list fetches
  final List<Order>? orders; // keep for fetching all orders

  OrderSuccess({this.orderId, this.orders});
}


class OrderFailure extends OrderState {
  final String message;
  OrderFailure(this.message);
}
