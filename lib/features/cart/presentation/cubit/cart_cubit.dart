import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  bool addToCart(BookModel book) {
    final existingItem = state.items.firstWhere(
      (item) => item.book.id == book.id,
      orElse: () => CartItem(book: book, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      return false;
    } else {
      final newItems = [...state.items, CartItem(book: book, quantity: 1)];
      _updateState(newItems);
      return true;
    }
  }

  void removeFromCart(int bookId) {
    final updatedItems =
        state.items.where((item) => item.book.id != bookId).toList();
    _updateState(updatedItems);
  }

  void clearCart() {
    emit(CartState());
  }

  void _updateState(List<CartItem> items) {
    final total = items.fold(0.0, (sum, item) {
      return sum + (item.book.price ?? 0) * item.quantity;
    });
    emit(CartState(items: items, totalPrice: total));
  }

  int get itemCount => state.items.length;
}
