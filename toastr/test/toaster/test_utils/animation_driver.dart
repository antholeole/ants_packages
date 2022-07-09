import 'package:flutter/material.dart';

typedef AnimatableBuilder = Widget Function(
    BuildContext context, Animation<double> animation);

class AnimationDriver extends StatefulWidget {
  final AnimatableBuilder builder;

  const AnimationDriver({Key? key, required this.builder}) : super(key: key);

  @override
  State<AnimationDriver> createState() => _AnimationDriverState();
}

class _AnimationDriverState extends State<AnimationDriver>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, Tween<double>(begin: 0.0, end: 1.0).animate(_controller));
  }
}
