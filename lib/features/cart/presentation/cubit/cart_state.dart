import 'package:readora/features/home/data/models/book_model.dart';

class CartItem {
  final BookModel book;
  final int quantity;

  CartItem({required this.book, this.quantity = 1});
}

class CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartState({this.items = const [], this.totalPrice = 0.0});

  CartState copyWith({List<CartItem>? items, double? totalPrice}) {
    return CartState(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
