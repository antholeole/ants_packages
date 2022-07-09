# Toaster Next

![image](https://raw.githubusercontent.com/antholeole/toaster_next/main/images/toasts.png)

A package used for displaying toasts. The main benefits of this package over other ones are:

- more customizeable: Use the default toasts, or create your own toasts.
- more flexibility: Toasts are generic enough to be applied for all usecases; error, warning, success... or create your own
- easily testable: Toaster uses a simple to mock API, so you can easily mock it in tests.
- easy to use: Add the Toaster widget to the widget tree, then begin adding toasts. Easy and simple.

### Quickstart

Refrence the example to see it in action.

quick setup:

1. add the `Toaster` to your widget tree with `Toaster.mount`:


```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toaster Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Toaster.mount(child: const Scaffold(body: AddToasts())),
    );
  }
}
```

2. Then, use the `Toaster`:

```dart
toaster.of(context).add(Toast(
    message: 'Im a message',
    type: warningToast
))
```

All done!

### Different Toast Types

Out of the box, warningToast, successToast, and errorToast are given. If you'd like to use toasts for other usecases 
(infoToast? notificationToast?) just create your own instance of `toastType`, like so:

```dart
final infoToast = ToastType(
 actionColor: Colors.red.blue900,
 iconBgColor: Colors.red.blue50,
 icon: const Icon(
   Icons.info,
   color: Colors.blue,
   size: ToastType.defaultToastIconSize,
 ));
```

this will customize the toast when you pass it into `toaster.of(context).add`. This seperates the toast styling from
the toast themselves, so we can utilize the same widget for different occasions (like errors, sucesses or warnings).

### Toast events

toasts have two event hooks: `onDismiss`, and `toastAction`. `onDismiss` is called when the toast is dismissed; when the 
user manually closes it, when the action is clicked, or when the toast expires. toastAction is triggered when the action button
on the toast is clicked; this is useful for confirmations; for example, if the user is about to do a destructive action, you can
show a toast that confirms that the user is going to do it when they click on the action.

```dart
Button(
    onClick: toaster.of(context).add(Toast(
        type: warningToast,
        message: 'are you sure you want to do destructive action?',
        action: ToastAction(
            action: destructiveActionHandler,
            text: 'yes, im sure'
        )
    ))
)
```

See the docs on the exposed types for more details and options.