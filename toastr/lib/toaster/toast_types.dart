import 'package:flutter/material.dart';

///customization options for the toast. [errorToast], [warningToast], and [successToast]
///are sensible defaults for toasts that fullfill most toast requirements. If you'd like to create
///your own toast, you may construct an instance of ToastType.
///
///[actionColor] is the color of the text that is prompting the user action; this is generally
///the same color as [iconBgColor], but much darker so it is readable.
///
///[icon] is the icon that is displayed with the toast.
///
///[iconBgColor] is the color that the icon will be painted on. This is useful in some designs, including the default toast.
///
///example:
///
///```dart
///final infoToast = ToastType(
/// actionColor: Colors.red.blue900,
/// iconBgColor: Colors.red.blue50,
/// icon: const Icon(
///   Icons.info,
///   color: Colors.blue,
///   size: ToastType.defaultToastIconSize,
/// ));
///```
class ToastType {
  static const defaultToastIconSize = 36.0;

  /// the color of the action text on the toast.
  final Color actionColor;
  //the icon on the toast.
  final Color iconBgColor;
  //the color of the background of the toast
  final Icon icon;

  const ToastType(
      {required this.actionColor,
      required this.iconBgColor,
      required this.icon});
}

final errorToast = ToastType(
    actionColor: Colors.red.shade900,
    iconBgColor: Colors.red.shade50,
    icon: const Icon(
      Icons.report,
      color: Colors.red,
      size: ToastType.defaultToastIconSize,
    ));

final warningToast = ToastType(
    actionColor: Colors.amber.shade900,
    iconBgColor: Colors.amber.shade50,
    icon: const Icon(
      Icons.warning_rounded,
      color: Colors.amber,
      size: ToastType.defaultToastIconSize,
    ));

final successToast = ToastType(
    actionColor: Colors.green.shade900,
    iconBgColor: Colors.green.shade50,
    icon: const Icon(
      Icons.done,
      color: Colors.green,
      size: ToastType.defaultToastIconSize,
    ));
