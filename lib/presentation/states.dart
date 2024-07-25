part of 'cubit_search_presenter.dart';

@immutable
class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {}

class SearchErrorState extends SearchState {
  final String message;

  SearchErrorState(this.message);
}

class SearchTabState extends SearchState {}
