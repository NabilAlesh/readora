import 'package:flutter/material.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/presentation/screens/book_details_screen.dart';

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authorName = book.authors.isNotEmpty ? book.authors.first.name : null;
    final priceText =
        book.price != null ? '\$${book.price!.toStringAsFixed(2)}' : null;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.black.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Container(
        width: 135,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    book.imageUrl != null
                        ? Image.network(
                          book.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                        : Container(color: const Color(0xFFD3D3D3)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (authorName != null) ...[
              const SizedBox(height: 2),
              Text(
                authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
            if (priceText != null) ...[
              const SizedBox(height: 4),
              Text(
                priceText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
