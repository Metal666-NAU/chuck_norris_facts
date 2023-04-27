import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../bloc/root/root.dart' as root;
import '../data/api/chuck_norris_api_repository.dart';
import 'home/api_response_details.dart';
import 'home/info.dart';

class HomePage extends StatelessWidget {
  static const double bottomSheetCollapsedHeight = 50;
  static const double bottomSheetDragAreaHeight = 35;

  const HomePage({super.key});

  @override
  Widget build(final context) => pageRoot(
        mainPanel(
          infoButton,
          logo,
          controlSection(
            jokeCategoryDropdown,
            refreshJokeCategoriesButton,
            retrieveRandomJokeButton,
          ),
          resultsSection,
        ),
        grabbingWidget,
        bottomPanel(
          apiRequestLog,
        ),
      );

  Widget pageRoot(
    final Widget mainPanel,
    final Widget Function(BuildContext context) grabbingWidget,
    final Widget bottomPanel,
  ) =>
      Builder(
        builder: (final context) => SnappingSheet(
          lockOverflowDrag: true,
          snappingPositions: const [
            SnappingPosition.pixels(
              positionPixels: bottomSheetCollapsedHeight,
              grabbingContentOffset: GrabbingContentOffset.top,
            ),
            SnappingPosition.factor(positionFactor: 0.4),
          ],
          grabbingHeight: bottomSheetDragAreaHeight,
          grabbing: grabbingWidget(context),
          sheetBelow: SnappingSheetContent(child: bottomPanel),
          child: mainPanel,
        ),
      );

  Widget mainPanel(
    final Widget Function(BuildContext context) infoButton,
    final Widget Function() logo,
    final Widget controlSection,
    final Widget Function(
      BuildContext context,
      List<Joke> retrievedJokes,
      Joke? expandedJoke,
    )
        resultsSection,
  ) =>
      Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Builder(
              builder: (final context) => infoButton(context),
            ),
          ),
          Column(
            children: [
              logo(),
              controlSection,
              Expanded(
                child: SingleChildScrollView(
                  child: BlocBuilder<root.Bloc, root.State>(
                    buildWhen: (final previous, final current) =>
                        previous.retrievedJokes != current.retrievedJokes ||
                        previous.expandedJoke != current.expandedJoke,
                    builder: (final context, final state) => resultsSection(
                      context,
                      state.retrievedJokes,
                      state.expandedJoke,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: bottomSheetCollapsedHeight + bottomSheetDragAreaHeight,
              )
            ],
          ),
        ],
      );

  Widget infoButton(final BuildContext context) => IconButton(
        onPressed: () async => await _openNewPage(
          context,
          const InfoPage(),
        ),
        color: Theme.of(context).hintColor,
        icon: const Icon(Icons.info_outline),
      );

  Widget logo() => Padding(
        padding: const EdgeInsets.all(12),
        child: Image.network(
          ChuckNorrisApi.logo().toString(),
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
          height: 150,
          cacheHeight: 300,
        ),
      );

  Widget controlSection(
    final Widget Function(
      BuildContext context,
      List<String> jokeCategories,
      String? selectedJokeCategory,
    )
        jokeCategoryDropdown,
    final Widget Function(BuildContext context) refreshJokeCategoriesButton,
    final Widget Function(
      BuildContext context,
      String? selectedJokeCategory,
      bool isRetrievingJoke,
    )
        retrieveRandomJokeButton,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<root.Bloc, root.State>(
                  buildWhen: (final previous, final current) =>
                      previous.jokeCategories != current.jokeCategories ||
                      previous.selectedJokeCategory !=
                          current.selectedJokeCategory,
                  builder: (final context, final state) => Expanded(
                    child: jokeCategoryDropdown(
                      context,
                      state.jokeCategories,
                      state.selectedJokeCategory,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Builder(
                  builder: (final context) =>
                      refreshJokeCategoriesButton(context),
                ),
              ],
            ),
          ),
          BlocBuilder<root.Bloc, root.State>(
            buildWhen: (final previous, final current) =>
                previous.selectedJokeCategory != current.selectedJokeCategory ||
                previous.isRetrievingJoke != current.isRetrievingJoke,
            builder: (final context, final state) => retrieveRandomJokeButton(
              context,
              state.selectedJokeCategory,
              state.isRetrievingJoke,
            ),
          ),
        ],
      );

  Widget jokeCategoryDropdown(
    final BuildContext context,
    final List<String> jokeCategories,
    final String? selectedJokeCategory,
  ) =>
      Theme(
        data: Theme.of(context).copyWith(focusColor: Colors.transparent),
        child: DropdownButtonFormField2<String>(
          value: selectedJokeCategory,
          isDense: false,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          hint: const Text('Select Category'),
          buttonStyleData: const ButtonStyleData(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          items: jokeCategories
              .map(
                (final String jokeCategory) => DropdownMenuItem<String>(
                  value: jokeCategory,
                  child: Text(
                    toBeginningOfSentenceCase(jokeCategory) ?? '[ERROR]',
                  ),
                ),
              )
              .toList(),
          onChanged: (final value) =>
              context.read<root.Bloc>().add(root.SelectJokeCategory(value)),
        ),
      );

  Widget refreshJokeCategoriesButton(final BuildContext context) => IconButton(
        onPressed: () =>
            context.read<root.Bloc>().add(const root.RefreshJokeCategories()),
        icon: const Icon(Icons.refresh),
      );

  Widget retrieveRandomJokeButton(
    final BuildContext context,
    final String? selectedJokeCategory,
    final bool isRetrievingJoke,
  ) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text('Gimme a joke!'),
            onPressed: isRetrievingJoke
                ? null
                : () => context
                    .read<root.Bloc>()
                    .add(const root.RetrieveRandomJoke()),
          ),
        ),
      );

  Widget resultsSection(
    final BuildContext context,
    final List<Joke> retrievedJokes,
    final Joke? expandedJoke,
  ) =>
      ExpansionPanelList(
        expansionCallback: (final panelIndex, final isExpanded) => context
            .read<root.Bloc>()
            .add(root.JokeExpanded(panelIndex, isExpanded)),
        children: retrievedJokes
            .map(
              (final Joke retrievedJoke) => ExpansionPanel(
                isExpanded: retrievedJoke == expandedJoke,
                canTapOnHeader: true,
                backgroundColor: ElevationOverlay.applySurfaceTint(
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.surfaceTint,
                  0.5,
                ),
                headerBuilder: (final context, final isExpanded) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(retrievedJoke.value.v ?? '[no value]'),
                ),
                body: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () async => await Clipboard.setData(
                                  ClipboardData(text: retrievedJoke.value.v),
                                ),
                                icon: const Icon(Icons.copy),
                                label: const Text('Copy'),
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () async => await _openNewPage(
                                  context,
                                  ApiResponseDetailsPage(
                                    retrievedJoke.response,
                                  ),
                                ),
                                icon: const Icon(Icons.open_in_new),
                                label: const Text('View raw'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );

  Widget grabbingWidget(final BuildContext context) => Card(
        margin: const EdgeInsets.all(0),
        elevation: 1.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
            bottom: Radius.zero,
          ),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          onTap: () {},
          child: Stack(
            children: [
              Center(
                child: Container(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 40,
                  height: 2,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Theme.of(context).colorScheme.onSecondary,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      );

  Widget bottomPanel(
    final Widget Function(List<ApiResponse> pastApiResponses) apiRequestLog,
  ) =>
      Card(
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        child: BlocBuilder<root.Bloc, root.State>(
          buildWhen: (final previous, final current) =>
              previous.pastApiResponses != current.pastApiResponses,
          builder: (final context, final state) =>
              apiRequestLog(state.pastApiResponses),
        ),
      );

  Widget apiRequestLog(final List<ApiResponse> pastApiResponses) =>
      ListView.builder(
        itemCount: pastApiResponses.length,
        itemBuilder: (final context, final index) {
          final ApiResponse apiResponse = pastApiResponses[index];

          return ListTile(
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            onTap: () async => await _openNewPage(
              context,
              ApiResponseDetailsPage(apiResponse),
            ),
            leading:
                Text('[${DateFormat.Hms().format(apiResponse.startedAt)}]'),
            title: Text(apiResponse.requestUrl ?? 'no url, what?!?'),
          );
        },
      );

  Future<Object?> _openNewPage(
    final BuildContext context,
    final Widget page,
  ) async =>
      await Navigator.of(context).push(
        PageRouteBuilder(
          transitionsBuilder: (
            final context,
            final Animation<double> animation,
            final Animation<double> secondaryAnimation,
            final Widget child,
          ) =>
              animation.status == AnimationStatus.reverse
                  ? SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.ease)),
                      ),
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(
                            begin: 1.1,
                            end: 1,
                          ),
                        ),
                        child: child,
                      ),
                    )
                  : SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.ease)),
                      ),
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(
                            begin: 1.1,
                            end: 1,
                          ),
                        ),
                        child: child,
                      ),
                    ),
          pageBuilder: (
            final context,
            final Animation<double> animation,
            final Animation<double> secondaryAnimation,
          ) =>
              page,
        ),
      );
}
