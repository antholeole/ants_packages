import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:toaster_next/toaster/toast_data.dart';
import 'package:toaster_next/toaster/toast_types.dart';

void main() {
  group('toast data', () {
    test('should use same hashcode as ID', () {
      final myToast = Toast(message: 'hi', type: errorToast, id: 'fakeId');
      expect(myToast.hashCode, myToast.id.hashCode);
    });

    group('completer', () {
      test('should call completer.complete(false) on toast dismissed',
          () async {
        final completer = Completer<bool>();
        final completerToast = Toast.completer(
            message: 'fake',
            type: errorToast,
            action: ToastAction(action: () {}, actionText: 'blah'),
            completer: completer);

        completerToast.onDismiss!();
        expect(await completer.future, false);
      });

      test('should call completer.complete(true) on toast action', () async {
        final completer = Completer<bool>();
        final completerToast = Toast.completer(
            message: 'fake',
            type: errorToast,
            action: ToastAction(action: () {}, actionText: 'blah'),
            completer: completer);

        completerToast.action!.action();
        expect(await completer.future, true);
      });
    });
  });
}
