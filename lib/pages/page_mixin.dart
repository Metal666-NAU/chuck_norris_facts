import 'package:flutter/material.dart';

mixin PageMixin {
  void showSnackbar(final BuildContext context, final String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        showCloseIcon: true,
      ),
    );
  }
}
