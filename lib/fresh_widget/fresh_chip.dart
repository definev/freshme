import 'package:flutter/material.dart';

class FreshChip extends StatelessWidget {
  const FreshChip({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final Color color;

  static const colors = [
    Colors.red,
    Color(0xFF127681),
    Color(0xFFfac70d),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, surfaceTintColor: color, backgroundColor: color,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
