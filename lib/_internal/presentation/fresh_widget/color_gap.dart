import 'package:flutter/material.dart';

class ColorGap extends StatelessWidget {
  const ColorGap({
    Key? key,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          bottom: -1,
          child: ColoredBox(color: backgroundColor),
        ),
        child,
      ],
    );
  }
}
