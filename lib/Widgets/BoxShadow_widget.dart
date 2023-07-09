import 'package:flutter/material.dart';

class BoxShadowWidget extends StatefulWidget {
  final VoidCallback onClicked;
  final Color backgroundColor;
  final Widget child;
  final double height;
  final double width;
  final Color? color;
  final Color? shadowColorLeft;
  final Color? shadowColorRight;
  final double? boxRadius;
  final Offset? rightSide;
  final Offset? leftSide;

  const BoxShadowWidget(
      {Key? key,
      required this.child,
      required this.height,
      required this.width,
      this.color,
      this.shadowColorLeft,
      this.shadowColorRight,
      required this.onClicked,
      required this.backgroundColor,
      this.boxRadius,
      this.rightSide,
      this.leftSide})
      : super(key: key);

  @override
  State<BoxShadowWidget> createState() => _BoxShadowWidgetState();
}

class _BoxShadowWidgetState extends State<BoxShadowWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.onClicked,
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  widget.boxRadius != null ? widget.boxRadius! : 50),
              color: widget.backgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color: widget.shadowColorLeft != null ? widget.shadowColorLeft! :Colors.white,
                  offset: widget.leftSide != null
                      ? widget.leftSide!
                      : const Offset(-18, -18),
                ),
                BoxShadow(
                  blurRadius: 30,
                  color: widget.shadowColorRight != null ? widget.shadowColorRight! : const Color(0xFFA7A9AF),
                  offset: widget.rightSide != null
                      ? widget.rightSide!
                      : const Offset(18, 18),
                ),
              ]),
          child: widget.child,
        ),
      ),
    );
  }
}
