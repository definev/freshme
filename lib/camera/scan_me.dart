import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:freshme/camera/smooth_radius/radius.dart';

class ScanMe extends StatelessWidget {
  const ScanMe({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
        child: Center(
          child: AspectRatio(
            aspectRatio: 5 / 6,
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(
                const Size(400, 600),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ScanMePainter(
                        const SmoothRadius(
                          cornerRadius: 40,
                          cornerSmoothing: 1,
                        ),
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: _ScanMeBar(theme.colorScheme.secondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanMeBar extends StatefulWidget {
  const _ScanMeBar(this.color);

  final Color color;

  @override
  State<_ScanMeBar> createState() => _ScanMeBarState();
}

class _ScanMeBarState extends State<_ScanMeBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _processScanAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _processScanAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 0.3),
          weight: 20,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.3, end: 1.0)
              .chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn)),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.7),
          weight: 20,
        ),
        TweenSequenceItem(
          tween:
              Tween(begin: 0.7, end: 0.0).chain(CurveTween(curve: Curves.ease)),
          weight: 30,
        ),
      ],
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.addListener(() => setState(() {}));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;

          return Stack(
            children: [
              Positioned(
                bottom: _processScanAnimation.value * size.height,
                height: size.height,
                width: size.width,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withOpacity(0.05),
                        widget.color.withOpacity(0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: _processScanAnimation.value * (size.height - 10),
                height: 20,
                width: size.width,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: theme.colorScheme.primary,
                    ),
                    child: const SizedBox(
                      height: 10,
                      width: double.maxFinite,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScanMePainter extends CustomPainter {
  _ScanMePainter(this.radius, {required this.color});

  final SmoothRadius radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint() //
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final height = size.height;
    final width = size.width;
    final rect = Offset.zero & size;

    var result = Path();

    /// Calculating only if values are different
    final processedRadius = ProcessedSmoothRadius(
      radius,
      width: width,
      height: height,
    );

    result
      ..addSmoothTopRight(processedRadius, rect)
      ..addSmoothBottomRight(processedRadius, rect)
      ..addSmoothBottomLeft(processedRadius, rect)
      ..addSmoothTopLeft(processedRadius, rect);
    result = result.transform(
      Matrix4.translationValues(rect.left, rect.top, 0).storage,
    );

    canvas.drawPath(result, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
