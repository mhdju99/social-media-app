import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/search/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) async {
      emit(SearchLoading());
       final results = await repository.searchPersons(event.query);
       results.fold((l) => emit(SearchError(l.errMessage)), (r) => emit(SearchLoaded(r)));
   
    });
  }
}
