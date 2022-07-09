import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:clock/clock.dart';

import 'package:flutter/material.dart';
import 'package:toaster_next/toaster/toast_types.dart';

/// an action for the toast. May be omitted if the toast has no action, and is only for
/// informational purposes.
///
/// [actionText] is the text that is used to prompt the user, and [action] is the function
/// that is called when the [actionText] is tapped.
class ToastAction {
  final String actionText;
  final void Function() action;

  const ToastAction({required this.actionText, required this.action});
}

/// a data object for passing info into the [toaster]. the [Toast] is identified by [id],
/// which defaults to a random string, but may be set if the toast requires an ID that must be reused or memorized.
/// [type] is a [ToastType] that tells the [toaster] how to style certain aspects of the toast; for instance, the
/// icon on the toast. see [ToastType] for more details.
///
/// [action.action] is called _only_ when the action text is tapped, not when the toast is dismissed; [onDismiss] is called
/// when the action is tapped _or_ when the toast is dismissed. in general, [onDismiss] can be used for resolving loading states,
/// for example, when a toast is used to confirm that a user meant to tap a button. [action.action] is used to actually perform the
/// action.
///
/// [Toast]s, by default, expire. This means that if a user does not interact with the toast, the toast will leave and trigger [onDismiss].
/// explicitly passing [null] to [duration] will cause the toast to force the user to dismiss it, else last forever.
///
/// [Toast.completer] may be used to create futures for if the user triggers the [action]; this is useful for situations where
/// the UI must wait for an action to be taken, like updating loading spinners.
class Toast {
  final String id;
  final String message;
  final ToastType type;
  final VoidCallback? onDismiss;
  final ToastAction? action;

  final DateTime created;
  final DateTime? expireAt;

  static String _generateId([int len = 30]) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  Toast({
    String? id,
    required this.message,
    required this.type,
    this.onDismiss,
    Duration? duration = const Duration(seconds: 5),
    this.action,
  })  : id = id ?? _generateId(),
        created = clock.now(),
        expireAt = duration != null ? clock.now().add(duration) : null;

  Toast.completer(
      {String? id,
      required this.message,
      required this.type,
      required ToastAction action,
      Duration? duration = const Duration(seconds: 5),
      required Completer<bool> completer})
      : created = clock.now(),
        expireAt = duration != null ? clock.now().add(duration) : null,
        id = id ?? _generateId(),
        action = ToastAction(
            action: () {
              completer.complete(true);
              action.action();
            },
            actionText: action.actionText),
        onDismiss = (() {
          if (!completer.isCompleted) completer.complete(false);
        });

  @override
  bool operator ==(covariant Toast other) {
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
