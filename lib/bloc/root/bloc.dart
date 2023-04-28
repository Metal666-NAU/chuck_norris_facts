part of 'root.dart';

class Bloc extends flutter_bloc.Bloc<Event, State> {
  final ChuckNorrisApiRepository chuckNorrisApiRepository;

  Bloc({required this.chuckNorrisApiRepository}) : super(const State()) {
    on<Startup>(
      (final event, final emit) => add(const RefreshJokeCategories()),
    );
    on<RefreshJokeCategories>((final event, final emit) async {
      emit(
        state.copyWith(
          jokeCategories: () => const [],
          selectedJokeCategory: () => null,
        ),
      );

      final ListApiResponse<String> response =
          await chuckNorrisApiRepository.getJokeCategories();

      emit(
        state.copyWith(
          jokeCategories: () => [
            null,
            ...response.data,
          ],
          pastApiResponses: () => [
            response,
            ...state.pastApiResponses,
          ],
        ),
      );
    });
    on<SelectJokeCategory>(
      (final event, final emit) =>
          emit(state.copyWith(selectedJokeCategory: () => event.jokeCategory)),
    );
    on<RetrieveRandomJoke>((final event, final emit) async {
      if (state.isRetrievingJoke) {
        return;
      }

      emit(
        state.copyWith(
          isRetrievingJoke: () => true,
        ),
      );

      final ObjectApiResponse<Joke> response = await chuckNorrisApiRepository
          .getRandomJoke(category: state.selectedJokeCategory);

      emit(
        state.copyWith(
          retrievedJokes: () => [
            response.data,
            ...state.retrievedJokes,
          ],
          pastApiResponses: () => [
            response,
            ...state.pastApiResponses,
          ],
          isRetrievingJoke: () => false,
        ),
      );
    });
    on<JokeExpanded>(
      (final event, final emit) => emit(
        state.copyWith(
          expandedJoke: () {
            final Joke expandedJoke = state.retrievedJokes[event.index];

            return state.expandedJoke == expandedJoke ? null : expandedJoke;
          },
        ),
      ),
    );
  }
}
