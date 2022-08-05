import 'package:flutter/material.dart';

class OptimizeOpacity extends StatelessWidget {
  const OptimizeOpacity({
    super.key,
    required this.opacity,
    required this.child,
  });

  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (opacity == 1) return child;
    if (opacity == 0) return const SizedBox();

    return Opacity(
      opacity: opacity,
      child: child,
    );
  }
}
