import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cv/cv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/root/root.dart' as root;
import 'data/api/chuck_norris_api_repository.dart';
import 'pages/home.dart';

void main() {
  registerCvConstructors();

  runApp(MainApp());

  doWhenWindowReady(() {
    appWindow.minSize = const Size(300, 350);
    appWindow.alignment = Alignment.center;
  });
}

void registerCvConstructors() {
  cvAddConstructor(Joke.new);
}

class MainApp extends StatelessWidget {
  final ThemeData _theme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );

  MainApp({super.key});

  @override
  Widget build(final context) => materialApp(
        home,
      );

  Widget materialApp(
    final Widget Function() home,
  ) =>
      RepositoryProvider(
        create: (final context) => ChuckNorrisApiRepository(),
        child: BlocProvider(
          lazy: false,
          create: (final context) => root.Bloc(
            chuckNorrisApiRepository: context.read<ChuckNorrisApiRepository>(),
          )..add(const root.Startup()),
          child: MaterialApp(
            title: 'Chuck Norris Facts',
            darkTheme: _theme,
            home: home(),
          ),
        ),
      );

  Widget home() => const Scaffold(body: HomePage());
}
