import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toaster_next/toaster.dart';
import 'package:toaster_next/toaster/default_toast_display.dart';
import 'package:toaster_next/toaster/toaster_display.dart';
import 'test_utils/pump_app.dart';

void main() {
  group('mount', () {
    testWidgets('should add ToasterDisplay to the widget tree', (tester) async {
      await tester.pumpApp(Toaster.mount(child: Container()));
      find.byType(ToasterDisplay);
    });

    testWidgets('should add toast using toastBuilder', (tester) async {
      const toastKey = Key('ImAToast');
      const getToastKey = Key('ToastMe');

      Widget toastBuilder(Toast __, Animation<double> _) => const Text(
            'hi',
            key: toastKey,
          );

      await tester.pumpApp(Toaster.mount(
          child: Builder(
              builder: (context) => TextButton(
                  key: getToastKey,
                  child: const Text('tap me to get toast'),
                  onPressed: () => Toaster.of(context).add(Toast(
                      duration: null, message: 'hi', type: warningToast)))),
          toastBuilder: toastBuilder));

      await tester.tap(find.byKey(getToastKey));
      await tester.pumpAndSettle();
      expect(find.byKey(toastKey), findsOneWidget);
    });

    testWidgets('should use DefaultToast on no ToastBuilder', (tester) async {
      const getToastKey = Key('ToastMe');

      await tester.pumpApp(Toaster.mount(
        child: Builder(
            builder: (context) => TextButton(
                key: getToastKey,
                child: const Text('tap me to get toast'),
                onPressed: () => Toaster.of(context).add(
                    Toast(duration: null, message: 'hi', type: errorToast)))),
      ));

      await tester.tap(find.byKey(getToastKey));
      await tester.pumpAndSettle();
      expect(find.byType(DefaultToast), findsOneWidget);
    });
  });

  group('of', () {
    testWidgets('should return toaster if in widget tree', (tester) async {
      const getToasterKey = Key('getMeMyToaster');
      Toaster? toaster;

      await tester.pumpApp(Toaster.mount(
          child: Builder(
              builder: (context) => TextButton(
                  key: getToasterKey,
                  onPressed: () => toaster = Toaster.of(context),
                  child: const Text('click me')))));

      await tester.tap(find.byKey(getToasterKey));
      expect(toaster, isNotNull);
    });
  });
}
