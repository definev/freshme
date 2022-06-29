import 'package:flutter/material.dart';

class FreshChip extends StatelessWidget {
  const FreshChip({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.color,
    this.height = 30,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final double height;

  static const colors = [
    Colors.red,
    Color(0xFF127681),
    Color(0xFFfac70d),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          surfaceTintColor: color,
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
