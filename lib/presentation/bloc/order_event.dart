import '../../data/models/order_model.dart';

abstract class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final Order order;
  CreateOrderEvent(this.order);
}

class FetchUserOrdersEvent extends OrderEvent {}
