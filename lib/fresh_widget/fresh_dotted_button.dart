import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FreshDottedButton extends HookWidget {
  const FreshDottedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.radius = 0,
    this.innerColor = Colors.white,
    this.innerBorderColor = Colors.black,
    this.outterColor = const Color(0xFFfac70d),
    this.innerBordered = true,
    this.outterBordered = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final double radius;
  final Color innerColor;
  final Color outterColor;
  final Color innerBorderColor;
  final bool innerBordered;
  final bool outterBordered;

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);

    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(4, 4),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(
                        cornerRadius: radius,
                        cornerSmoothing: 1,
                      ),
                    ),
                    side: outterBordered
                        ? const BorderSide(width: 2)
                        : BorderSide.none,
                  ),
                  color: outterColor,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isPressed.value ? 1 : 0),
              duration: 150.ms,
              curve: Curves.ease,
              builder: (context, value, child) => Transform.translate(
                offset: const Offset(2, 2) * value,
                child: child,
              ),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(
                        cornerRadius: radius,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  color: innerColor,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: radius,
                            cornerSmoothing: 1,
                          ),
                        ),
                        side: innerBordered
                            ? BorderSide(width: 2, color: innerBorderColor)
                            : BorderSide.none,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    surfaceTintColor: MaterialStateProperty.all(Colors.white),
                    animationDuration: 300.ms,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                    ),
                  ),
                  onPressed: () {
                    if (isPressed.value) return;
                    isPressed.value = true;
                    Future.delayed(150.ms, () {
                      isPressed.value = false;
                      Future.delayed(150.ms, onPressed);
                    });
                  },
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
