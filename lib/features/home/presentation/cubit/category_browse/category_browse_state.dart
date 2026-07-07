import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/data/models/category_model.dart';

abstract class CategoryBrowseState {}

class CategoryBrowseInitial extends CategoryBrowseState {}

class CategoryBrowseLoaded extends CategoryBrowseState {
  final List<CategoryModel> categories;
  final List<BookModel> filteredBooks;
  final int? selectedCategoryId;
  final CategoryModel currentCategory;

  CategoryBrowseLoaded({
    required this.categories,
    required this.filteredBooks,
    required this.selectedCategoryId,
    required this.currentCategory,
  });
}
