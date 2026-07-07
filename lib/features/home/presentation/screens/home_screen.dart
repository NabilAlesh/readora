import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/core/constant/app_color.dart';
import 'package:readora/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:readora/features/home/presentation/cubit/home/home_state.dart';
import 'package:readora/features/home/presentation/screens/all_books_screen.dart';
import 'package:readora/features/home/presentation/screens/category_browse_screen.dart';
import 'package:readora/features/home/presentation/widgets/home/book_card.dart';
import 'package:readora/features/home/presentation/widgets/home/category_card.dart';
import 'package:readora/features/home/presentation/widgets/home/custom_bottom_nav_bar.dart';
import 'package:readora/features/home/presentation/widgets/home/custom_search_bar.dart';
import 'package:readora/features/home/presentation/widgets/home/section_header.dart';
import 'package:readora/features/home/presentation/widgets/home/top_header_section.dart';
import 'package:readora/features/my_library/presentation/pages/my_library_screen.dart';
import 'package:readora/features/my_orders/presentation/pages/orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _HomeContent(),
      const MyLibraryScreen(),
      const OrdersScreen(),
      const _PlaceholderScreen(title: 'my favorite'),
      const _PlaceholderScreen(title: 'my profile'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchHomeData(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderSection(),
              const SizedBox(height: 18),
              const CustomSearchBar(),
              const SizedBox(height: 25),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return SectionHeader(
                    title: "Categories",
                    showMore: true,
                    onTap:
                        state is HomeLoaded
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CategoryBrowseScreen(
                                        categories: state.categories,
                                        allBooks: state.latestBooks,
                                      ),
                                ),
                              );
                            }
                            : null,
                  );
                },
              ),
              const SizedBox(height: 14),
              const _CategoriesList(),
              const SizedBox(height: 25),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return SectionHeader(
                    title: "Latest Books",
                    showMore: true,
                    onTap:
                        state is HomeLoaded
                            ? () {
                              final reversedAllBooks =
                                  state.latestBooks.reversed.toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AllBooksScreen(
                                        books: reversedAllBooks,
                                      ),
                                ),
                              );
                            }
                            : null,
                  );
                },
              ),
              const SizedBox(height: 14),
              const _LatestBooksList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestBooksList extends StatelessWidget {
  const _LatestBooksList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HomeLoaded) {
          final reversedBooks = state.latestBooks.reversed.toList();
          final booksCount =
              reversedBooks.length > 5 ? 5 : reversedBooks.length;
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: booksCount,
              itemBuilder: (context, index) {
                return BookCard(book: reversedBooks[index]);
              },
            ),
          );
        } else if (state is HomeError) {
          return SizedBox(
            height: 250,
            child: Center(child: Text('Error: ${state.message}')),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _CategoriesList extends StatelessWidget {
  const _CategoriesList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HomeLoaded) {
          final categoriesCount =
              state.categories.length > 5 ? 5 : state.categories.length;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categoriesCount,
              itemBuilder: (context, index) {
                return CategoryCard(
                  category: state.categories[index],
                  allBooks: state.latestBooks,
                  color: null,
                );
              },
            ),
          );
        } else if (state is HomeError) {
          return SizedBox(
            height: 150,
            child: Center(child: Text('Error: ${state.message}')),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'صفحة $title قيد التطوير',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
