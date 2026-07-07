import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/core/constant/urls.dart';
import 'package:readora/core/network/network_service.dart';
import 'package:readora/features/home/data/models/auther_model.dart';
import 'package:readora/features/home/data/models/book_model.dart';
import 'package:readora/features/home/data/models/category_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final booksResponse = await Network.getData(url: Urls.showBooks);
      final categoriesResponse = await Network.getData(
        url: Urls.showCategories,
      );
      final authorsResponse = await Network.getData(url: Urls.showAuthers);

      if (booksResponse.data == null || booksResponse.data['data'] == null) {
        emit(HomeError('البيانات غير متوفرة'));
        return;
      }

      final books =
          (booksResponse.data['data'] as List)
              .map((json) => BookModel.fromJson(json))
              .toList();

      final categories =
          (categoriesResponse.data['data'] as List)
              .map((json) => CategoryModel.fromJson(json))
              .toList();

      final authors =
          (authorsResponse.data['data'] as List)
              .map((json) => AuthorModel.fromJson(json))
              .toList();

      emit(
        HomeLoaded(
          latestBooks: books,
          categories: categories,
          authors: authors,
        ),
      );
    } catch (e) {
      emit(HomeError('فشل تحميل البيانات: $e'));
    }
  }
}
