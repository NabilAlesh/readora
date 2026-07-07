import 'package:readora/features/home/data/models/book_model.dart';

class OrderModel {
  final int id;
  final String orderDate;
  final double totalPrice;
  final String status;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderDate: json['created_at'] ?? json['order_date'] ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'completed',
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OrderItem {
  final int id;
  final BookModel book;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.book,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      book: BookModel.fromJson(json['book'] ?? {}),
      quantity: json['quantity'] ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
