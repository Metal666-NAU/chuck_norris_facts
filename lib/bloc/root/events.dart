part of 'root.dart';

abstract class Event {
  const Event();
}

class Startup extends Event {
  const Startup();
}

class RefreshJokeCategories extends Event {
  const RefreshJokeCategories();
}

class SelectJokeCategory extends Event {
  final String? jokeCategory;

  const SelectJokeCategory(this.jokeCategory);
}

class RetrieveRandomJoke extends Event {
  const RetrieveRandomJoke();
}

class JokeExpanded extends Event {
  final int index;
  final bool isExpanded;

  const JokeExpanded(this.index, this.isExpanded);
}
