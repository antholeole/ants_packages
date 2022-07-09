import 'package:flutter/cupertino.dart';
import 'package:toaster_next/toaster/toast_data.dart';
import 'package:toaster_next/toaster/toaster_display.dart';
import 'default_toast_display.dart';

typedef ToastBuilder = Widget Function(
  Toast toast,
  Animation<double> animation,
);

abstract class Toaster {
  /// manually removes a toast with [toastId] from the toasts.
  /// will not trigger the toasts toastsAction, but will trigger the toasts dismissAction.
  void remove(String toastId);

  /// add a toast.
  ///
  /// example:
  ///
  /// ```dart
  /// toaster.of(context).add(Toast(
  ///   duration: Duration(seconds: 45), //explicitly say 'null' if you want the toast to never expire.
  ///   message: 'Im a message',
  ///   action: ToastAction(
  ///           action: () => print('clicked on action'),
  ///             actionText: 'Click me'),
  ///   onDissmiss: () => "Ive been dismissed; the action was not performed",
  ///   type: errorToast)
  /// ).
  /// ```
  void add(Toast toast);

  /// view all the toasts; usually you won't use this method, but it might be useful
  /// if you're attempting to see if a toast was already inserted:
  ///
  /// example:
  /// ```dart
  /// if (!toaster.of(context).toasts.any((toast) => toast.id == 'uniqueToast'))  {
  ///   toaster.of(context).add(Toast(
  ///     type: warningToast,
  ///     id: 'uniqueToast',
  ///     message: "my unique toast"
  ///   ))
  /// }
  /// ```
  List<Toast> get toasts;

  /// mount the [Toaster] in the widget tree for reference later. [Toaster] uses an [InheritedWidget],
  /// so all rules apply; a [Toaster] may be shadowed by a new [Toaster], and the [BuildContext] used to refrence
  /// the [Toaster] must be in the same tree as the [Toaster].
  ///
  /// [toastBuilder] is used to build toasts; it takes a toast, as well as an animation used to coordinate the
  /// toast's animation in and out.
  static Widget mount(
      {Key? key, required Widget child, ToastBuilder? toastBuilder}) {
    return ToasterDisplay(
      toastBuilder: toastBuilder ??
          (toast, animation) => DefaultToast(
                toast: toast,
                animation: animation,
              ),
      child: child,
      key: key,
    );
  }

  /// refrence the nearest [Toaster].
  static Toaster of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ToasterStateFinder>();
    assert(result != null, 'No toaster found in context');

    return result!.toasterState;
  }
}
