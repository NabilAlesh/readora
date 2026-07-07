import 'package:readora/features/my_orders/data/models/order_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  OrdersLoaded({required this.orders});
}

class OrderDetailsLoaded extends OrdersState {
  final OrderModel order;
  OrderDetailsLoaded({required this.order});
}

class OrdersError extends OrdersState {
  final String message;
  OrdersError(this.message);
}
