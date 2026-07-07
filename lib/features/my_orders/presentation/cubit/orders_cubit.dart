import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:readora/core/constant/urls.dart';
import 'package:readora/core/network/exception_handler.dart';
import 'package:readora/core/network/network_service.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/my_orders/data/models/order_model.dart';
import 'orders-state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  Map<int, BookModel> _allBooksMap = {};

  Future<void> fetchOrders() async {
    emit(OrdersLoading());
    try {
      final response = await Network.getData(
        url: Urls.orders,
        requiresAuth: true,
      );
      if (response.data == null || response.data['data'] == null) {
        emit(OrdersError('البيانات غير متوفرة'));
        return;
      }
      final orders =
          (response.data['data'] as List)
              .map((json) => OrderModel.fromJson(json))
              .toList();
      emit(OrdersLoaded(orders: orders));
    } on DioException catch (e) {
      emit(OrdersError(exceptionsHandle(error: e)));
    } catch (e) {
      emit(OrdersError('حدث خطأ غير معروف: $e'));
    }
  }

  Future<void> fetchOrderDetails(int orderId) async {
    emit(OrdersLoading());
    try {
      final orderResponse = await Network.getData(
        url: '${Urls.orders}/$orderId',
        requiresAuth: true,
      );

      if (orderResponse.data == null || orderResponse.data['data'] == null) {
        emit(OrdersError('البيانات غير متوفرة'));
        return;
      }

      final allBooksResponse = await Network.getData(
        url: Urls.showBooks,
        requiresAuth: false,
      );

      if (allBooksResponse.data != null &&
          allBooksResponse.data['data'] != null) {
        final allBooks =
            (allBooksResponse.data['data'] as List)
                .map((json) => BookModel.fromJson(json))
                .toList();
        _allBooksMap = {for (var book in allBooks) book.id: book};
      }

      final orderJson = orderResponse.data['data'];
      final order = OrderModel.fromJson(orderJson);

      final enhancedItems =
          order.items.map((item) {
            final fullBook = _allBooksMap[item.book.id];
            if (fullBook != null && fullBook.authors.isNotEmpty) {
              return OrderItem(
                id: item.id,
                book: fullBook,
                quantity: item.quantity,
                price: item.price,
              );
            }
            return item;
          }).toList();

      final enhancedOrder = OrderModel(
        id: order.id,
        orderDate: order.orderDate,
        totalPrice: order.totalPrice,
        status: order.status,
        items: enhancedItems,
      );

      emit(OrderDetailsLoaded(order: enhancedOrder));
    } on DioException catch (e) {
      emit(OrdersError(exceptionsHandle(error: e)));
    } catch (e) {
      emit(OrdersError('حدث خطأ غير معروف: $e'));
    }
  }

  Future<void> addOrder(List<int> bookIds) async {
    try {
      final response = await Network.postData(
        url: Urls.orders,
        data: {'book_ids': bookIds, 'source': 'purchase'},
        requiresAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMsg = response.data['message'] ?? 'فشل إضافة الطلب';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: errorMsg,
        );
      }

      await fetchOrders();
    } on DioException catch (e) {
      final errorMsg = exceptionsHandle(error: e);
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
