import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/core/constant/app_color.dart';
import 'package:readora/core/utils/helper/snackbar_helper.dart';
import 'package:readora/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:readora/features/my_library/presentation/cubit/my_library_state.dart';
import 'package:readora/features/my_orders/presentation/cubit/orders_cubit.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookModel book;
  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isPurchased = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfPurchased();
  }

  Future<void> _checkIfPurchased() async {
    final cubit = context.read<MyLibraryCubit>();
    await cubit.fetchMyBooks();
    if (cubit.state is MyLibraryLoaded) {
      final books = (cubit.state as MyLibraryLoaded).books;
      setState(() {
        isPurchased = books.any((b) => b.id == widget.book.id);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrdersCubit()),
        BlocProvider(create: (context) => MyLibraryCubit()),
      ],
      child: _BookDetailsContent(
        book: widget.book,
        isPurchased: isPurchased,
        isLoading: isLoading,
        onPurchaseSuccess: () {
          setState(() => isPurchased = true);
        },
      ),
    );
  }
}

class _BookDetailsContent extends StatelessWidget {
  final BookModel book;
  final bool isPurchased;
  final bool isLoading;
  final VoidCallback onPurchaseSuccess;

  const _BookDetailsContent({
    Key? key,
    required this.book,
    required this.isPurchased,
    required this.isLoading,
    required this.onPurchaseSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFree = book.price == null || book.price == 0;
    final authorsText =
        book.authors.isNotEmpty
            ? book.authors.map((a) => a.name).join(', ')
            : 'مؤلف غير معروف';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 280,
                  width: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        book.imageUrl != null
                            ? Image.network(
                              book.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                            : Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.book,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                book.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                authorsText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),

              if (book.categories.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children:
                      book.categories.map((cat) {
                        return Chip(
                          label: Text(
                            cat.name,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: AppColors.bg.withOpacity(0.5),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoColumn(
                      'Publish Date',
                      book.publishDate ?? 'Not Available',
                    ),
                    Container(height: 30, width: 1, color: Colors.grey[300]),
                    _buildInfoColumn('ISBN', book.isbn ?? 'N/A'),
                    if (book.price != null) ...[
                      Container(height: 30, width: 1, color: Colors.grey[300]),
                      _buildInfoColumn('price', '${book.price} \$'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'About the Book',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book.description ?? 'لا يوجد وصف متاح لهذا الكتاب حالياً.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildActionButtons(context, isFree),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isFree) {
    if (isFree || isPurchased) {
      return ElevatedButton(
        onPressed: () {
          if (book.pdfUrl != null) {
            print('فتح الرابط: ${book.pdfUrl}');
            SnackBarHelper.showInfo(context, ' جاري فتح الكتاب...');
          } else {
            SnackBarHelper.showError(
              context,
              'لا يوجد ملف PDF متاح لهذا الكتاب',
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          isFree ? ' Read for Free' : ' Read Book',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () => _showPurchaseDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Purchase Book',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              final cartCubit = context.read<CartCubit>();
              final added = cartCubit.addToCart(book);
              if (added) {
                SnackBarHelper.showSuccess(
                  context,
                  ' Book added to cart successfully',
                );
              } else {
                SnackBarHelper.showInfo(
                  context,
                  ' Book is already in the cart',
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 4),
                Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Confirm Purchase'),
            content: Text(
              'Do you want to purchase the book "${book.title}" for ${book.price} \$?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  try {
                    await context.read<OrdersCubit>().addOrder([book.id]);

                    onPurchaseSuccess();

                    final myLibraryCubit = context.read<MyLibraryCubit>();
                    await myLibraryCubit.fetchMyBooks();

                    final ordersCubit = context.read<OrdersCubit>();
                    await ordersCubit.fetchOrders();

                    SnackBarHelper.showSuccess(
                      context,
                      'Book purchased successfully',
                    );
                  } catch (e) {
                    SnackBarHelper.showError(
                      context,
                      'Failed to purchase book: $e',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Confirm Purchase'),
              ),
            ],
          ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
