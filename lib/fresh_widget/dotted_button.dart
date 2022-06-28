import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DottedButton extends HookWidget {
  const DottedButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(width: 2),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isPressed.value ? 1 : 0),
              duration: 300.ms,
              curve: Curves.ease,
              builder: (context, value, child) => Transform.translate(
                offset: const Offset(2, 2) * value,
                child: child,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2),
                ),
                child: GestureDetector(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      surfaceTintColor: MaterialStateProperty.all(Colors.white),
                      animationDuration: 300.ms,
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    onPressed: () {
                      if (isPressed.value) return;
                      isPressed.value = true;
                      Future.delayed(300.ms, () {
                        isPressed.value = false;
                        Future.delayed(300.ms, onPressed);
                      });
                    },
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
