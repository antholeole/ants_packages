import 'package:flutter/material.dart';
import 'package:toaster_next/toaster.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'toaster Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Toaster.mount(child: const Scaffold(body: AddToasts())),
    );
  }
}

class AddToasts extends StatefulWidget {
  const AddToasts({Key? key}) : super(key: key);

  @override
  State<AddToasts> createState() => _AddToastsState();
}

class _AddToastsState extends State<AddToasts> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: const Text('Add Toast'),
      onPressed: () {
        setState(() {
          counter++;
        });
        Toaster.of(context).add(Toast(
            action: ToastAction(
                // ignore: avoid_print
                action: () => print('clicked on action'),
                actionText: 'Click me'),
            duration: null,
            onDismiss: () =>
                // ignore: avoid_print
                print('Ive been dismissed; the action was not performed'),
            message: counter.toString(),
            type: counter % 3 == 0
                ? warningToast
                : counter % 3 == 1
                    ? successToast
                    : errorToast));
      },
    ));
  }
}
