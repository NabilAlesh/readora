import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/data/models/category_model.dart';
import 'package:readora/features/home/presentation/cubit/category_browse/category_browse_cubit.dart';
import 'package:readora/features/home/presentation/cubit/category_browse/category_browse_state.dart';
import 'package:readora/features/home/presentation/screens/category_books_screen.dart';
import 'package:readora/features/home/presentation/widgets/home/category_tabs_bar.dart';
import 'package:readora/features/home/presentation/widgets/home/custom_search_bar.dart';
import 'package:readora/features/home/presentation/widgets/home/horizontal_books_list.dart';
import 'package:readora/features/home/presentation/widgets/home/section_header.dart';

class CategoryBrowseScreen extends StatelessWidget {
  final List<CategoryModel> categories;
  final List<BookModel> allBooks;

  const CategoryBrowseScreen({
    Key? key,
    required this.categories,
    required this.allBooks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              CategoryBrowseCubit(allCategories: categories, allBooks: allBooks)
                ..initData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Category',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<CategoryBrowseCubit, CategoryBrowseState>(
          builder: (context, state) {
            if (state is CategoryBrowseLoaded) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: CustomSearchBar(),
                  ),

                  CategoryTabsBar(
                    categories: state.categories,
                    selectedCategoryId: state.selectedCategoryId,
                    onCategorySelected: (id) {
                      context.read<CategoryBrowseCubit>().selectCategory(id);
                    },
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: SectionHeader(
                              title: "New Book List",
                              showMore: true,
                              onTap:
                                  () => _navigateToCategoryScreen(
                                    context,
                                    state.currentCategory,
                                  ),
                            ),
                          ),
                          HorizontalBooksList(books: state.filteredBooks),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: SectionHeader(
                              title: "Most Popular",
                              showMore: true,
                              onTap:
                                  () => _navigateToCategoryScreen(
                                    context,
                                    state.currentCategory,
                                  ),
                            ),
                          ),
                          HorizontalBooksList(
                            books: state.filteredBooks.reversed.toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _navigateToCategoryScreen(BuildContext context, CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                CategoryBooksScreen(category: category, allBooks: allBooks),
      ),
    );
  }
}
