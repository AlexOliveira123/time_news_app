import 'package:flutter/material.dart';

import '../../../ui/ui.dart';
import 'ui.dart';

Widget makeSearchPage() {
  return SearchPage(
    presenter: makeCubitSearchPresenter(),
  );
}
