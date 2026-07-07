import 'package:readora/features/home/data/models/book_model.dart';

abstract class MyLibraryState {}

class MyLibraryInitial extends MyLibraryState {}

class MyLibraryLoading extends MyLibraryState {}

class MyLibraryLoaded extends MyLibraryState {
  final List<BookModel> books;
  MyLibraryLoaded({required this.books});
}

class MyLibraryError extends MyLibraryState {
  final String message;
  MyLibraryError(this.message);
}
