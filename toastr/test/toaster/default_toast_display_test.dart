import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toaster_next/toaster/default_toast_display.dart';
import 'package:toaster_next/toaster/toast_data.dart';
import 'package:toaster_next/toaster/toast_types.dart';
import 'test_utils/animation_driver.dart';
import 'test_utils/mocks.dart';
import 'test_utils/pump_app.dart';

void main() {
  group('defaultToastDisplay', () {
    testWidgets('should render message', (tester) async {
      const toastMessage = 'hi';

      await tester.pumpApp(AnimationDriver(
          builder: (context, animation) => DefaultToast(
                animation: animation,
                toast: Toast(message: toastMessage, type: errorToast),
              )));

      expect(find.text(toastMessage), findsOneWidget);
    });

    testWidgets('should call Toaster.remove(toastId) on close toast tap',
        (tester) async {
      const toastId = 'ToastId';
      final mockToaster = MockToaster();

      await tester.pumpApp(MockToaster.mount(
        toaster: mockToaster,
        child: AnimationDriver(
            builder: (context, animation) => DefaultToast(
                  animation: animation,
                  toast: Toast(
                    id: toastId,
                    message: 'h',
                    type: successToast,
                  ),
                )),
      ));

      await tester.tap(find.byIcon(DefaultToast.closeIcon));
      verify(() => mockToaster.remove(toastId)).called(1);
    });

    group('action', () {
      testWidgets('should render action text', (tester) async {
        const actionText = 'alligators in my soup';

        await tester.pumpApp(AnimationDriver(
            builder: (context, animation) => DefaultToast(
                  animation: animation,
                  toast: Toast(
                      message: 'h',
                      type: errorToast,
                      action:
                          ToastAction(action: () {}, actionText: actionText)),
                )));

        expect(find.text(actionText), findsOneWidget);
      });

      testWidgets('should call callback on action', (tester) async {
        const actionText = 'alligators in my soup';
        final actionCompleter = Completer<void>();

        await tester.pumpApp(MockToaster.mount(
          toaster: MockToaster(),
          child: AnimationDriver(
              builder: (context, animation) => DefaultToast(
                    animation: animation,
                    toast: Toast(
                        message: 'h',
                        type: errorToast,
                        action: ToastAction(
                            action: actionCompleter.complete,
                            actionText: actionText)),
                  )),
        ));

        await tester.tap(find.text(actionText));
        expect(actionCompleter.isCompleted, isTrue);
      });

      testWidgets('should call Toaster.remove(toast) on action',
          (tester) async {
        const actionText = 'alligators in my soup';
        const toastId = 'ToastId';
        final mockToaster = MockToaster();

        await tester.pumpApp(MockToaster.mount(
          toaster: mockToaster,
          child: AnimationDriver(
              builder: (context, animation) => DefaultToast(
                    animation: animation,
                    toast: Toast(
                        id: toastId,
                        message: 'h',
                        type: errorToast,
                        action:
                            ToastAction(action: () {}, actionText: actionText)),
                  )),
        ));

        await tester.tap(find.text(actionText));
        verify(() => mockToaster.remove(toastId)).called(1);
      });
    });

    group('ToastType', () {
      const customToastDataClass = ToastType(
          actionColor: Colors.pink,
          iconBgColor: Colors.green,
          icon: Icon(Icons.ac_unit));

      testWidgets('should set icon', (tester) async {
        await tester.pumpApp(AnimationDriver(
            builder: (context, animation) => DefaultToast(
                  animation: animation,
                  toast: Toast(message: 'blah', type: customToastDataClass),
                )));

        expect(find.byIcon(customToastDataClass.icon.icon!), findsOneWidget);
      });
    });
  });
}
