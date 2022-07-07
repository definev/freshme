import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum FreshAngle { left, right, balance }

class FreshFrame extends HookWidget {
  const FreshFrame({
    Key? key,
    required this.angle,
    required this.child,
    this.noise = 0.15,
    this.padding = const EdgeInsets.all(6),
  }) : super(key: key);

  final FreshAngle angle;
  final Widget child;
  final EdgeInsets padding;
  final double noise;

  static const _angle = [
    -.6,
    -.5,
    -.4,
    .4,
    .55,
    .6,
  ];

  @override
  Widget build(BuildContext context) {
    final random = useMemoized(() => Random());
    final rotateVibrant = useState(() {
      if (angle == FreshAngle.balance) {
        return random.nextInt(6);
      }
      return random.nextInt(3) + (angle == FreshAngle.left ? 0 : 3);
    }());

    return Stack(
      children: [
        Positioned.fill(
          child: Transform.rotate(
            angle: _angle[rotateVibrant.value] * noise,
            child: Transform.scale(
              scale: 1.01,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFfac70d),
                  border: Border.all(width: 2),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Transform.rotate(
            angle: angle == FreshAngle.balance
                ? 0
                : _angle[rotateVibrant.value] * 0.07,
            child: DottedBorder(
              strokeWidth: 2,
              borderType: BorderType.RRect,
              dashPattern: const [3, 3, 1],
              strokeCap: StrokeCap.round,
              radius: const Radius.circular(2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
