import 'package:readora/core/constant/urls.dart';
import 'category_model.dart';
import 'auther_model.dart';

class BookModel {
  final int id;
  final String title;
  final String? isbn;
  final String? description;
  final double? price;
  final String? publishDate;
  final String? imageUrl;
  final String? pdfUrl;
  final List<CategoryModel> categories;
  final List<AuthorModel> authors;

  BookModel({
    required this.id,
    required this.title,
    this.isbn,
    this.description,
    this.price,
    this.publishDate,
    this.imageUrl,
    this.pdfUrl,
    this.categories = const [],
    this.authors = const [],
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'] ?? json['book_title'] ?? '';

    final isbn = json['isbn'] ?? json['isbn_number'];

    final description = json['description'] ?? json['short_description'];

    final publishDate = json['publish_date'];

    double? price;
    if (json['price'] != null) {
      price = double.tryParse(json['price'].toString());
    }

    String? imageUrl = json['image'] ?? json['image_url'];
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = '${Urls.storageUrl}$imageUrl';
    }

    String? pdfUrl = json['file_path'] ?? json['pdf_url'];
    if (pdfUrl != null && !pdfUrl.startsWith('http')) {
      pdfUrl = '${Urls.storageUrl}$pdfUrl';
    }

    return BookModel(
      id: json['id'] ?? 0,
      title: title,
      isbn: isbn,
      description: description,
      price: price,
      publishDate: publishDate,
      imageUrl: imageUrl,
      pdfUrl: pdfUrl,
      categories:
          (json['categories'] as List?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      authors:
          (json['authors'] as List?)
              ?.map((e) => AuthorModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
