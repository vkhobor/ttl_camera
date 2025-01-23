import 'package:flutter/material.dart';

class TimedWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const TimedWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<TimedWidget> createState() => _TimedWidgetState();
}

class _TimedWidgetState extends State<TimedWidget> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _visible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _visible ? widget.child : const SizedBox.shrink();
  }
}
