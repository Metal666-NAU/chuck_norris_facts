import 'package:colored_json/colored_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/api/chuck_norris_api_repository.dart';
import 'page_base.dart';

class ApiResponseDetailsPage extends PageBase {
  final ApiResponse apiResponse;

  const ApiResponseDetailsPage(this.apiResponse, {super.key});

  @override
  Widget build(final context) => root(
        mainPanel(
          infoSection,
          dataSection,
        ),
      );

  Widget mainPanel(
    final Widget Function(BuildContext context) infoSection,
    final Widget Function(BuildContext context) dataSection,
  ) =>
      Builder(
        builder: (final context) => Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              infoSection(context),
              Expanded(child: dataSection(context)),
            ],
          ),
        ),
      );

  Widget _section({
    required final BuildContext context,
    final bool expanded = false,
    required final String headerText,
    required final List<Widget> bodyItems,
  }) {
    Widget sectionBody(final List<Widget> bodyItems) => Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: bodyItems,
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              headerText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        expanded
            ? Expanded(child: sectionBody(bodyItems))
            : sectionBody(bodyItems),
      ],
    );
  }

  Widget infoSection(final BuildContext context) => _section(
        context: context,
        headerText: 'Info:',
        bodyItems: [
          SelectableText(
            'Request sent at: ${apiResponse.startedAt}',
          ),
          SelectableText(
            'Response took: ${apiResponse.duration.inMilliseconds} ms',
          ),
        ],
      );

  Widget dataSection(final BuildContext context) {
    final Color bracketColor = Theme.of(context).colorScheme.tertiary;
    final Color keyColor = Theme.of(context).colorScheme.primary;
    final Color separatorColor = Theme.of(context).colorScheme.onBackground;
    final Color valueColor = Theme.of(context).colorScheme.onPrimaryContainer;

    return _section(
      context: context,
      expanded: true,
      headerText: 'Data:',
      bodyItems: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: ColoredJson(
                data: apiResponse.rawData,
                textStyle: const TextStyle(fontSize: 18),
                curlyBracketColor: bracketColor,
                squareBracketColor: bracketColor,
                keyColor: keyColor,
                colonColor: separatorColor,
                stringColor: valueColor,
                boolColor: valueColor,
                doubleColor: valueColor,
                intColor: valueColor,
                nullColor: valueColor,
                commaColor: separatorColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton.icon(
            onPressed: () async => await Clipboard.setData(
              ClipboardData(text: apiResponse.rawData),
            ),
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ),
      ],
    );
  }
}
