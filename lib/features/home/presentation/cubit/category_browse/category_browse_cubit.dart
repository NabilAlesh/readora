import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/data/models/category_model.dart';
import 'category_browse_state.dart';

class CategoryBrowseCubit extends Cubit<CategoryBrowseState> {
  final List<CategoryModel> allCategories;
  final List<BookModel> allBooks;

  CategoryBrowseCubit({required this.allCategories, required this.allBooks})
    : super(CategoryBrowseInitial());

  void initData() {
    if (allCategories.isNotEmpty) {
      selectCategory(allCategories.first.id);
    }
  }

  void selectCategory(int categoryId) {
    final filtered =
        allBooks.where((book) {
          return book.categories.any((cat) => cat.id == categoryId);
        }).toList();

    final currentCat = allCategories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => CategoryModel(id: 0, name: 'Category'),
    );

    emit(
      CategoryBrowseLoaded(
        categories: allCategories,
        filteredBooks: filtered,
        selectedCategoryId: categoryId,
        currentCategory: currentCat,
      ),
    );
  }
}
