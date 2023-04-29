import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/api/chuck_norris_api_repository.dart';
import 'page_base.dart';

class InfoPage extends PageBase {
  static const List<String> installedPackages = [
    'colored_json',
    'cv',
    'dropdown_button2',
    'flutter_bloc',
    'http',
    'intl',
    'mason_cli',
    'snapping_sheet',
    'url_launcher',
  ];

  const InfoPage({super.key});

  @override
  Widget build(final context) => root(
        mainPanel(),
      );

  Widget mainPanel() {
    Widget section({
      final bool isExpanded = false,
      required final String header,
      required final Widget content,
    }) =>
        Expanded(
          flex: isExpanded ? 1 : 0,
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    header,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  flex: isExpanded ? 1 : 0,
                  child: content,
                ),
              ],
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        section(
          isExpanded: true,
          header: 'Used packages:',
          content: ListView.builder(
            itemCount: installedPackages.length,
            itemBuilder: (final context, final index) {
              final String package = installedPackages[index];

              return ListTile(
                title: Text(package),
                trailing: IconButton(
                  onPressed: () async => await launchUrl(
                    Uri.https('pub.dev', 'packages/$package'),
                  ),
                  icon: const Icon(Icons.open_in_new),
                ),
              );
            },
          ),
        ),
        section(
          header: 'Used API:',
          content: Padding(
            padding: const EdgeInsets.all(4),
            child: TextButton(
              onPressed: () async => await launchUrl(
                ChuckNorrisApi.api(),
              ),
              child: Row(
                children: const [
                  Expanded(child: Text(ChuckNorrisApi.address)),
                  Icon(Icons.open_in_new)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
