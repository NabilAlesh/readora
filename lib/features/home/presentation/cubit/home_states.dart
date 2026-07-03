abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> categories;
  final List<dynamic> latestBooks;

  HomeLoaded({required this.categories, required this.latestBooks});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}