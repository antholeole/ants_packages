import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toaster_next/toaster/toaster_interface.dart';

import 'toast_data.dart';

class ToasterStateFinder extends InheritedWidget {
  final Toaster toasterState;

  const ToasterStateFinder({
    Key? key,
    required this.toasterState,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ToasterStateFinder oldWidget) =>
      listEquals(toasterState.toasts, oldWidget.toasterState.toasts);
}

class ToasterDisplay extends StatefulWidget {
  final Widget child;
  final ToastBuilder toastBuilder;

  const ToasterDisplay(
      {Key? key, required this.child, required this.toastBuilder})
      : super(key: key);

  @override
  State<ToasterDisplay> createState() => _ToasterDisplayState();
}

class _ToasterDisplayState extends State<ToasterDisplay> implements Toaster {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  LinkedHashMap<String, Toast> _toasts = LinkedHashMap();
  Map<String, Timer> _timers = {};

  @override
  Widget build(BuildContext context) {
    return ToasterStateFinder(
        toasterState: this,
        child: DefaultTextStyle(
          style: const TextStyle(
              color: Colors.black, decoration: TextDecoration.none),
          child: Builder(
              builder: (context) => Stack(
                    children: [
                      widget.child,
                      Align(
                        alignment: Alignment.topCenter,
                        child: SafeArea(
                          child: AnimatedList(
                            key: _animatedListKey,
                            initialItemCount: toasts.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index, animation) =>
                                widget.toastBuilder(
                              toasts[index],
                              animation,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
        ));
  }

  @override
  void add(Toast toast) {
    final LinkedHashMap<String, Toast> newToasts = LinkedHashMap.from(_toasts)
      ..[toast.id] = toast;

    final Map<String, Timer> newTimers = toast.expireAt != null
        ? (Map.from(_timers)
          ..[toast.id] = Timer(toast.expireAt!.difference(DateTime.now()),
              () => remove(toast.id)))
        : _timers;

    setState(() {
      _toasts = newToasts;
      _timers = newTimers;
    });

    //-1 since we just added a new toast
    _animatedListKey.currentState!.insertItem(0);
  }

  @override
  void remove(String toastId) {
    final toasts = _toasts.values.toList();
    int toastIndex;
    Toast? removedToast;
    for (toastIndex = 0; toastIndex < toasts.length; toastIndex++) {
      if (toasts[toastIndex].id == toastId) {
        removedToast = toasts[toastIndex];
        break;
      }
    }

    if (removedToast == null) {
      return;
    }

    if (removedToast.onDismiss != null) {
      removedToast.onDismiss!();
    }

    setState(() {
      _timers = Map<String, Timer>.from(_timers)..remove(toastId);
      _toasts = LinkedHashMap<String, Toast>.from(_toasts)..remove(toastId);
    });

    _animatedListKey.currentState!.removeItem(
      toasts.length - 1 - toastIndex,
      (context, animation) => widget.toastBuilder(
        removedToast!,
        animation,
      ),
    );
  }

  @override
  List<Toast> get toasts => _toasts.values.toList().reversed.toList();
}
