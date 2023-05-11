import 'package:flutter/material.dart';

class BoxShadowWidget extends StatefulWidget {
  final Widget child;
  final double height;
  final double width;
  final Color? color;

  const BoxShadowWidget(
      {Key? key,
      required this.child,
      required this.height,
      required this.width,
      this.color})
      : super(key: key);

  @override
  State<BoxShadowWidget> createState() => _BoxShadowWidgetState();
}

class _BoxShadowWidgetState extends State<BoxShadowWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color:  widget.color ?? Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade700,
              blurRadius: 20,
              offset: const Offset(4, 4),
              spreadRadius: -5,
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 20,
              offset: Offset(-4, -4),
              spreadRadius: -5,
            ),
          ],
        ),
        child: Center(
          child: widget.child,
        ));
  }
}
