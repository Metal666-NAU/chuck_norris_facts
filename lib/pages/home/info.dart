import 'package:flutter/material.dart';
import 'package:flutter_custom_license_page/flutter_custom_license_page.dart';

import 'page_base.dart';

class InfoPage extends PageBase {
  const InfoPage({super.key});

  @override
  Widget build(final context) => root(
        mainPanel(),
      );

  Widget mainPanel() => CustomLicensePage((
        final context,
        final licenseData,
      ) =>
          Text(''));
}
