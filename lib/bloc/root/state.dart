part of 'root.dart';

class State {
  final List<String> jokeCategories;
  final String? selectedJokeCategory;
  final List<ApiResponse> pastApiResponses;
  final bool isRetrievingJoke;
  final List<Joke> retrievedJokes;
  final Joke? expandedJoke;

  const State({
    this.jokeCategories = const [],
    this.selectedJokeCategory,
    this.pastApiResponses = const [],
    this.isRetrievingJoke = false,
    this.retrievedJokes = const [],
    this.expandedJoke,
  });

  State copyWith({
    final List<String> Function()? jokeCategories,
    final String? Function()? selectedJokeCategory,
    final List<ApiResponse> Function()? pastApiResponses,
    final bool Function()? isRetrievingJoke,
    final List<Joke> Function()? retrievedJokes,
    final Joke? Function()? expandedJoke,
  }) =>
      State(
        jokeCategories: jokeCategories == null
            ? this.jokeCategories
            : jokeCategories.call(),
        selectedJokeCategory: selectedJokeCategory == null
            ? this.selectedJokeCategory
            : selectedJokeCategory.call(),
        pastApiResponses: pastApiResponses == null
            ? this.pastApiResponses
            : pastApiResponses.call(),
        isRetrievingJoke: isRetrievingJoke == null
            ? this.isRetrievingJoke
            : isRetrievingJoke.call(),
        retrievedJokes: retrievedJokes == null
            ? this.retrievedJokes
            : retrievedJokes.call(),
        expandedJoke:
            expandedJoke == null ? this.expandedJoke : expandedJoke.call(),
      );
}
