import 'package:flutter/material.dart';
import '../../../../core/constant/app_color.dart';

class CategoryBooksScreen extends StatelessWidget {
  final Map<String, dynamic> category;
  final List<dynamic> allBooks;

  const CategoryBooksScreen({
    Key? key,
    required this.category,
    required this.allBooks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredBooks = allBooks.where((book) {
      final bookCategory = book['category'];
      if (bookCategory is Map) {
        return bookCategory['name'] == category['name'];
      }
      return bookCategory == category['name'];
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          category['name'] ?? 'Category Books',
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: filteredBooks.isEmpty
          ? const Center(
              child: Text(
                'No books added to this category yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
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
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return _StaticBookCard(book: book);
                },
              ),
            ),
    );
  }
}

class _StaticBookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const _StaticBookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              image: book['image'] != null && book['image'].isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(book['image']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: book['image'] == null || book['image'].isEmpty
                ? const Center(
                    child: Icon(Icons.book, size: 45, color: Colors.grey),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          book['title'] ?? 'Unknown Title',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          book['author'] ?? 'Unknown Author',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}