import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toaster_next/toaster/toast_data.dart';
import 'package:toaster_next/toaster/toast_types.dart';
import 'package:toaster_next/toaster/toaster_interface.dart';

import 'test_utils/pump_app.dart';

void main() {
  Future<T> runFakeAsync<T>(Future<T> Function(FakeAsync time) f) async {
    return fakeAsync((FakeAsync time) async {
      bool pump = true;
      final Future<T> future = f(time).whenComplete(() => pump = false);
      while (pump) {
        time.flushMicrotasks();
      }
      return future;
    });
  }

  group('toaster display', () {
    Widget buildInvoker({
      required Key invokerKey,
      required void Function(BuildContext context) onInvoke,
    }) {
      return Builder(
          builder: (context) => TextButton(
              key: invokerKey,
              onPressed: () => onInvoke(context),
              child: const Text('NOT A TOAST MESSAGE DONT LOOK FOR ME')));
    }

    Future<void> invoke(WidgetTester tester, Key invokerKey) async {
      await tester.tap(find.byKey(invokerKey));
    }

    testWidgets('should add toast on add', (tester) async {
      const addToastKey = Key('hiasdasd');
      const toastMessage = 'hi there';

      await tester.pumpApp(Toaster.mount(
          child: buildInvoker(
              invokerKey: addToastKey,
              onInvoke: (context) => Toaster.of(context).add(Toast(
                  duration: null, message: toastMessage, type: errorToast)))));
      await invoke(tester, addToastKey);
      await tester.pumpAndSettle();

      expect(find.text(toastMessage), findsOneWidget);
    });

    testWidgets('should remove toast on remove', (tester) async {
      const addToastKey = Key('hiasdasd');
      const removeToastKey = Key('removeTOast');
      const toastId = 'toastId';
      const toastMessage = 'hi there';

      await tester.pumpApp(Toaster.mount(
          child: Column(
        children: [
          const SizedBox(
            //don't cover the buttons
            height: 50,
          ),
          buildInvoker(
              invokerKey: addToastKey,
              onInvoke: (context) => Toaster.of(context).add(Toast(
                  id: toastId,
                  duration: null,
                  message: toastMessage,
                  type: errorToast))),
          buildInvoker(
              invokerKey: removeToastKey,
              onInvoke: (context) => Toaster.of(context).remove(toastId)),
        ],
      )));

      await invoke(tester, addToastKey);
      await tester.pumpAndSettle();
      expect(find.text(toastMessage), findsOneWidget);

      await invoke(tester, removeToastKey);
      await tester.pumpAndSettle();
      expect(find.text(toastMessage), findsNothing);
    });

    testWidgets('should invoke onDismiss on remove', (tester) async {
      const addToastKey = Key('hiasdasd');
      const removeToastKey = Key('removeTOast');
      const toastId = 'toastId';
      const toastMessage = 'hi there';
      final dismissCompleter = Completer();

      await tester.pumpApp(Toaster.mount(
          child: Column(
        children: [
          const SizedBox(
            //don't cover the buttons
            height: 50,
          ),
          buildInvoker(
              invokerKey: addToastKey,
              onInvoke: (context) => Toaster.of(context).add(Toast(
                  onDismiss: dismissCompleter.complete,
                  id: toastId,
                  duration: null,
                  message: toastMessage,
                  type: errorToast))),
          buildInvoker(
              invokerKey: removeToastKey,
              onInvoke: (context) => Toaster.of(context).remove(toastId)),
        ],
      )));

      await invoke(tester, addToastKey);
      await tester.pumpAndSettle();
      expect(find.text(toastMessage), findsOneWidget);

      await invoke(tester, removeToastKey);
      await tester.pumpAndSettle();
      expect(find.text(toastMessage), findsNothing);

      expect(dismissCompleter.isCompleted, isTrue);
    });

    testWidgets('toast should decay after timer', (tester) async {
      await runFakeAsync((async) async {
        const addToastKey = Key('hiasdasd');
        const toastMessage = 'hi there';
        const toastDuration = Duration(seconds: 5);

        await tester.pumpApp(Toaster.mount(
            child: buildInvoker(
                invokerKey: addToastKey,
                onInvoke: (context) => Toaster.of(context).add(Toast(
                    duration: toastDuration,
                    message: toastMessage,
                    type: errorToast)))));

        await invoke(tester, addToastKey);
        await tester.pumpAndSettle();
        expect(find.text(toastMessage), findsOneWidget);

        async.elapse(toastDuration + const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(find.text(toastMessage), findsNothing);
      });
    });
  });
}
