// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';
import 'package:social_media_app/features/search/search_repository.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  GetUserIdUseCase getUserIdUseCase;

  SearchBloc(
  { required this.repository,
  required  this.getUserIdUseCase,}
  ) : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) async {
      final userId = await getUserIdUseCase();

      emit(SearchLoading());
      final results = await repository.searchPersons(event.query);
      results.fold((l) => emit(SearchError(l.errMessage)), (r) {
        final results = r.where(
          (element) => element.id != userId,
        ).toList();
        emit(SearchLoaded(results));
      });
    });
  }
}
