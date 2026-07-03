import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:readora/core/constant/urls.dart';
import 'package:readora/core/network/network_service.dart';
// import 'package:readora/core/network/urls.dart';
// import 'package:readora/core/network/network.dart'; 
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final responses = await Future.wait([
        Network.getData(url: Urls.showCategories),
        Network.getData(url: Urls.showBooks),
      ]);

      final Response categoriesResponse = responses[0];
      final Response booksResponse = responses[1];

      List<dynamic> categories = categoriesResponse.data;
      List<dynamic> books = booksResponse.data;

      emit(HomeLoaded(
        categories: categories,
        latestBooks: books,
      ));
    } on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        emit(HomeError(message: error.response?.data['message'] ?? 'Error'));
      } else {
        emit(HomeError(message: 'Unknown error occurred'));
      }
    }
  }
}