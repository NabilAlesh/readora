import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:readora/core/constant/urls.dart';
import 'package:readora/core/network/exception_handler.dart';
import 'package:readora/core/network/network_service.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'my_library_state.dart';

class MyLibraryCubit extends Cubit<MyLibraryState> {
  MyLibraryCubit() : super(MyLibraryInitial());

  Map<int, BookModel> _allBooksMap = {};

  Future<void> fetchMyBooks() async {
    emit(MyLibraryLoading());
    try {
      final libraryResponse = await Network.getData(
        url: Urls.myLibrary,
        requiresAuth: true,
      );

      if (libraryResponse.data == null ||
          libraryResponse.data['data'] == null) {
        emit(MyLibraryError('البيانات غير متوفرة'));
        return;
      }

      List<dynamic> booksData =
          libraryResponse.data['data'] is List
              ? libraryResponse.data['data']
              : [];

      if (booksData.isEmpty) {
        emit(MyLibraryLoaded(books: []));
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

      final booksWithAuthors =
          booksData.map((json) {
            final libraryBook = BookModel.fromJson(json);
            final fullBook = _allBooksMap[libraryBook.id];
            if (fullBook != null && fullBook.authors.isNotEmpty) {
              return BookModel(
                id: libraryBook.id,
                title: libraryBook.title,
                isbn: libraryBook.isbn,
                description: libraryBook.description,
                price: libraryBook.price,
                publishDate: libraryBook.publishDate,
                imageUrl: libraryBook.imageUrl,
                pdfUrl: libraryBook.pdfUrl,
                categories: libraryBook.categories,
                authors: fullBook.authors,
              );
            }
            return libraryBook;
          }).toList();

      emit(MyLibraryLoaded(books: booksWithAuthors));
    } on DioException catch (e) {
      emit(MyLibraryError(exceptionsHandle(error: e)));
    } catch (e) {
      emit(MyLibraryError('حدث خطأ غير معروف: $e'));
    }
  }
}
