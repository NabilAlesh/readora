import 'package:flutter/material.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/presentation/widgets/home/book_card.dart';

class HorizontalBooksList extends StatelessWidget {
  final List<BookModel> books;

  const HorizontalBooksList({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child:
          books.isEmpty
              ? const Center(child: Text("لا توجد كتب حالياً"))
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCard(book: books[index]);
                },
              ),
    );
  }
}
