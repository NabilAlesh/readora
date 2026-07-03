import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/app_color.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import 'category_books_screen.dart';

class CategoryBrowseScreen extends StatelessWidget {
  final List<dynamic> categories;
  final List<dynamic> allBooks;

  const CategoryBrowseScreen({
    Key? key,
    required this.categories,
    required this.allBooks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<HomeCubit>(context),
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
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: CustomSearchBar(),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        bool isSelected = index == 0; 
                        
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryColor : Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              category['name'] ?? 'Category',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: SectionHeader(
                              title: "New Book List",
                              showMore: true,
                              onTap: () => _navigateToCategoryScreen(
                                context,
                                state.categories.isNotEmpty ? state.categories[0] : {'name': 'General'},
                              ),
                            ),
                          ),
                          
                          _buildHorizontalBooksList(state.latestBooks),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: SectionHeader(
                              title: "Most Popular",
                              showMore: true,
                              onTap: () => _navigateToCategoryScreen(
                                context,
                                state.categories.isNotEmpty ? state.categories[0] : {'name': 'General'},
                              ),
                            ),
                          ),
                          
                          _buildHorizontalBooksList(state.latestBooks.reversed.toList()),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          },
        ),
      ),
    );
  }

  void _navigateToCategoryScreen(BuildContext context, Map<String, dynamic> category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryBooksScreen(
          category: category,
          allBooks: allBooks,
        ),
      ),
    );
  }

  Widget _buildHorizontalBooksList(List<dynamic> books) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: books.length > 5 ? 5 : books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      image: book['image'] != null && book['image'].isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(book['image']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: book['image'] == null || book['image'].isEmpty
                        ? const Center(child: Icon(Icons.book, size: 40, color: Colors.grey))
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  book['title'] ?? 'Unknown Title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  book['author'] ?? 'Unknown Author',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search books, authors...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showMore;
  final VoidCallback onTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.showMore = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        if (showMore)
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'See All',
              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}