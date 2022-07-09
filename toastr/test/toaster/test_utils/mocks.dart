import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import 'package:toaster_next/toaster/toaster_display.dart';
import 'package:toaster_next/toaster/toaster_interface.dart';

class MockToaster extends Mock implements Toaster {
  static Widget mount(
      {Key? key, required Widget child, required Toaster toaster}) {
    return ToasterStateFinder(
      child: child,
      toasterState: toaster,
    );
  }
}
