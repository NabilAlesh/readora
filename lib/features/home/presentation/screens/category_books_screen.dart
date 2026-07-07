import 'package:flutter/material.dart';
import 'package:readora/core/constant/app_color.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/data/models/category_model.dart';
import 'package:readora/features/home/presentation/widgets/home/book_card.dart';

class CategoryBooksScreen extends StatelessWidget {
  final CategoryModel category;
  final List<BookModel> allBooks;

  const CategoryBooksScreen({
    Key? key,
    required this.category,
    required this.allBooks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredBooks =
        allBooks.where((book) {
          return book.categories.any((cat) => cat.id == category.id);
        }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          category.name,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          filteredBooks.isEmpty
              ? const Center(
                child: Text(
                  'لا توجد كتب مضافة لهذا التصنيف حالياً.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredBooks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return BookCard(book: book);
                  },
                ),
              ),
    );
  }
}
