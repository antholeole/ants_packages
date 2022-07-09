import 'package:flutter/material.dart';
import 'package:toaster_next/toaster.dart';

class DefaultToast extends StatelessWidget {
  static const closeIcon = Icons.close;

  final Toast toast;
  final Animation<double> animation;

  const DefaultToast({
    Key? key,
    required this.toast,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: SizeTransition(
          sizeFactor: animation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2.5),
                    blurRadius: 3,
                    spreadRadius: 1.5,
                    color: Colors.grey.shade200)
              ],
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: toast.type.iconBgColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: toast.type.icon,
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: _buildMessage(context)),
                ),
                GestureDetector(
                  onTap: () => Toaster.of(context).remove(toast.id),
                  child: Icon(
                    closeIcon,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final List<Widget> children = [
      Text(
        toast.message,
      ),
    ];

    if (toast.action != null) {
      children.add(GestureDetector(
        onTap: () {
          toast.action!.action();
          Toaster.of(context).remove(toast.id);
        },
        child: Text(
          toast.action!.actionText,
          style: TextStyle(color: toast.type.actionColor),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
