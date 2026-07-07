import 'package:flutter/material.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/data/models/category_model.dart';
import 'package:readora/features/home/presentation/screens/category_books_screen.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final List<BookModel> allBooks;
  final Color? color;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.allBooks,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    CategoryBooksScreen(category: category, allBooks: allBooks),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color ?? Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.category, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
