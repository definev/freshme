import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FreshTextButton extends HookWidget {
  const FreshTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final pressed = useState(false);

    return SizedBox(
      height: 48,
      child: TextButton(
        style: TextButton.styleFrom(shape: const RoundedRectangleBorder()),
        onPressed: () {
          if (pressed.value) return;
          pressed.value = true;
          Future.delayed(300.ms, () {
            pressed.value = false;
            onPressed();
          });
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              widthFactor: 1.0,
              child: Text(text),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TweenAnimationBuilder<double>(
                    duration: 300.ms,
                    tween: Tween(begin: 1, end: pressed.value ? 0 : 1),
                    curve: Curves.easeOutCirc,
                    builder: (context, value, child) {
                      return Divider(
                        height: 1,
                        thickness: 2,
                        endIndent: 30 * value,
                        color: const Color(0xFFfac70d),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
