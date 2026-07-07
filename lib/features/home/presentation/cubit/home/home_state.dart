import 'package:readora/features/home/data/models/auther_model.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/data/models/category_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<BookModel> latestBooks;
  final List<CategoryModel> categories;
  final List<AuthorModel> authors;

  HomeLoaded({
    required this.latestBooks,
    required this.categories,
    required this.authors,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
