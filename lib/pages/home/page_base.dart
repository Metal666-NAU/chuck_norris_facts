import 'package:flutter/material.dart';

abstract class PageBase extends StatelessWidget {
  const PageBase({super.key});

  Widget root(final Widget content) => Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(builder: closeButton),
            Expanded(
              child: content,
            ),
          ],
        ),
      );

  Widget closeButton(final BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      );
}
