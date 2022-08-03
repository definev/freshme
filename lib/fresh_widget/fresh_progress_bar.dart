import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FreshProgressBar extends HookWidget {
  const FreshProgressBar({
    Key? key,
    required this.percent,
    required this.direction,
    required this.length,
    this.thickness = 12,
  }) : super(key: key);

  final double percent;
  final Axis direction;
  final double length;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    // final animationController = useAnimationController(duration: 600.ms);
    // final movingAnimation = useAnimation(
    //   animationController.drive(
    //     TweenSequence<double>(
    //       [
    //         TweenSequenceItem<double>(
    //           tween: CurveTween(curve: Curves.linear),
    //           weight: 100,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    // final animateState = useRef<AnimationStatus?>(null);
    // useEffect(() {
    //   animationController.forward();
    //   animationController.addStatusListener((status) {
    //     if (animateState.value == AnimationStatus.forward) {
    //       if (status == AnimationStatus.completed) {
    //         animationController.value = 0;
    //         animationController.forward();
    //       }
    //     }
    //   });
    //   animateState.value = AnimationStatus.forward;
    //   animationController.forward();

    //   return null;
    // }, []);
    const movingAnimation = 0.0;

    return RepaintBoundary(
      child: SizedBox(
        height: thickness,
        width: length,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: thickness / 2,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: thickness,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: Colors.green,
                ),
                child: const CustomPaint(
                  foregroundPainter: _DashedPainter(movingAnimation),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  const _DashedPainter(this.animate);

  final double animate;

  @override
  void paint(Canvas canvas, Size size) {
    const spacer = 3.0;
    const outterSpacer = 3.0;
    final paint = Paint() //
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.clipRect(Offset.zero & size);
    for (int space = -1; space < size.width ~/ spacer; space += 1) {
      canvas.drawLine(
        Offset(
          space * spacer +
              outterSpacer * space + //
              animate * (outterSpacer * 2),
          size.height - 4,
        ),
        Offset(
          (space + 1) * spacer +
              outterSpacer * space +
              animate * (outterSpacer * 2),
          4,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
