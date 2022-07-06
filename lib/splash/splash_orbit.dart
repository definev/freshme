import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freshme/resources/resources.dart';
import 'package:simple_animations/simple_animations.dart';

enum _OrbitProps { rotate }

class _Orbit {
  final String image;
  final Color color;
  final double size;
  final Offset offset;

  _Orbit({
    required this.image,
    required this.color,
    required this.size,
    required this.offset,
  });
}

class SplashOrbit extends StatefulWidget {
  const SplashOrbit({super.key});

  @override
  State<SplashOrbit> createState() => _SplashOrbitState();
}

class _SplashOrbitState extends State<SplashOrbit> {
  final _orbitTween = TimelineTween<_OrbitProps>()
    ..addScene(
      begin: 0.ms,
      end: 30000.ms,
    ).animate(
      _OrbitProps.rotate,
      tween: Tween<double>(begin: 0.0, end: 100 * pi),
    );

  List<_Orbit> get orbits => [
        _Orbit(
          size: 55.0,
          color: const Color(0xFFEAD68E),
          image: Images.environmentProtection,
          offset: const Offset(240, 40),
        ),
        _Orbit(
          size: 65.0,
          color: Colors.pink.shade200,
          image: Images.foodDonation,
          offset: const Offset(-27, 100),
        ),
        _Orbit(
          size: 55.0,
          color: Colors.blue.shade200,
          image: Images.giveLove,
          offset: const Offset(65, 255),
        ),
        _Orbit(
          size: 50.0,
          color: Colors.green.shade200,
          image: Images.historyBook,
          offset: const Offset(100, -15),
        ),
        _Orbit(
          image: Images.volunteering,
          color: Colors.deepOrange.shade200,
          size: 65.0,
          offset: const Offset(235, 200),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(
            const Size(300, 300),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxDimension =
                  min(constraints.maxHeight, constraints.maxWidth);

              return SizedBox(
                height: maxDimension,
                width: maxDimension,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: SizedBox(
                        height: maxDimension,
                        width: maxDimension,
                        child: LoopAnimation<TimelineValue<_OrbitProps>>(
                          tween: _orbitTween,
                          duration: 1000.seconds,
                          builder: (context, child, value) => Transform.rotate(
                            angle: value.get(_OrbitProps.rotate),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: PlayAnimation<double>(
                                    tween: Tween(
                                      begin: 0.0,
                                      end: 265.0 / 300 * maxDimension,
                                    ),
                                    duration: 300.ms,
                                    curve: Curves.ease,
                                    builder: (context, child, value) =>
                                        DottedBorder(
                                      borderType: BorderType.Circle,
                                      dashPattern: const [30, 10],
                                      strokeWidth: 2,
                                      child: SizedBox(
                                        height: value,
                                        width: value,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Transform.scale(
                                    scale: 1.15,
                                    child: PlayAnimation<double>(
                                      tween: Tween(
                                        begin: 0.0,
                                        end: 265.0 / 300 * maxDimension,
                                      ),
                                      duration: 300.ms,
                                      curve: Curves.ease,
                                      builder: (context, child, value) =>
                                          DottedBorder(
                                        borderType: BorderType.Circle,
                                        dashPattern: const [30, 10],
                                        strokeWidth: 1.5,
                                        color: Colors.black.withOpacity(0.12),
                                        child: SizedBox(
                                          height: value,
                                          width: value,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Transform.scale(
                                    scale: 1.3,
                                    child: PlayAnimation<double>(
                                      tween: Tween(
                                        begin: 0.0,
                                        end: 265.0 / 300 * maxDimension,
                                      ),
                                      duration: 300.ms,
                                      curve: Curves.ease,
                                      builder: (context, child, value) =>
                                          DottedBorder(
                                        borderType: BorderType.Circle,
                                        dashPattern: const [30, 10],
                                        strokeWidth: 1,
                                        color: Colors.black.withOpacity(0.05),
                                        child: SizedBox(
                                          height: value,
                                          width: value,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                for (final orbit in orbits)
                                  Positioned(
                                    left: orbit.offset.dx * maxDimension / 300,
                                    top: orbit.offset.dy * maxDimension / 300,
                                    child: Transform.rotate(
                                      angle: -value.get(_OrbitProps.rotate),
                                      child: PlayAnimation<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: 500.ms,
                                        curve: Curves.ease,
                                        builder: (context, child, value) =>
                                            Opacity(
                                          opacity: value,
                                          child: Container(
                                            height:
                                                orbit.size * maxDimension / 300,
                                            width:
                                                orbit.size * maxDimension / 300,
                                            decoration: BoxDecoration(
                                              color: orbit.color,
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              height: 30 * maxDimension / 300,
                                              width: 30 * maxDimension / 300,
                                              child: Image.asset(orbit.image),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: _circleImage(maxDimension),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _circleImage(double maxWidth) {
    final ratio = maxWidth / 300;

    return SizedBox(
        height: 200 * ratio,
        width: 200 * ratio,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 200 * ratio,
                width: 200 * ratio,
                decoration: BoxDecoration(
                  color: const Color(0xFF84b296),
                  shape: BoxShape.circle,
                  border: Border.all(width: 2),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 160 * ratio,
                width: 160 * ratio,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 2),
                ),
                clipBehavior: Clip.none,
                child: MirrorAnimation<double>(
                  duration: 2000.ms,
                  curve: Curves.easeOutBack,
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, child, value) => Transform.translate(
                    offset: Offset(0, 5 + -20 * value),
                    child: Transform.scale(
                      scale: 1.5 + 0.15 * value,
                      child: child,
                    ),
                  ),
                  child: ClipPath(
                    clipper: _ImageClipping(),
                    child: Image.asset(
                      Images.boyCarringBox,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class _ImageClipping extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width * 1 / 3,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - (size.width * 2 / 3 * 0.6),
      size.height - 30,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
