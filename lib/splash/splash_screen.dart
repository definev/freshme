import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freshme/fresh_widget/dotted_button.dart';
import 'package:freshme/home/home_screen.dart';
import 'package:freshme/resources/resources.dart';
import 'package:gap/gap.dart';
import 'package:simple_animations/simple_animations.dart';

enum _CircleProps { innerSize, outterSide, rotate }

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

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SplashOrbit(),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        color: Colors.green.shade200,
                      ),
                      width: double.maxFinite,
                      height: 200,
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.bottomCenter,
                      child: SeparatedRow(
                        separatorBuilder: () => const Gap(20),
                        children: AnimateList(
                          effects: [
                            const FadeEffect(),
                            const MoveEffect(),
                          ],
                          children: [
                            Expanded(
                              child: DottedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(CommunityMaterialIcons.google),
                                  ],
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen())),
                              ),
                            ),
                            Expanded(
                              child: DottedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(CommunityMaterialIcons.facebook),
                                  ],
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen())),
                              ),
                            ),
                            Expanded(
                              child: DottedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(CommunityMaterialIcons.apple),
                                  ],
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen())),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(35, 16, 35, 110),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Text(
                                    'Bắt đầu thay đổi thế giới\nngay từ hôm nay',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ) //
                                      .animate()
                                      .fadeIn()
                                      .move(
                                        begin: const Offset(0, 20),
                                        end: Offset.zero,
                                      ),
                                  const Gap(20),
                                  const Text(
                                    'Hãy ủng hộ FRESHME, cung cấp những vật dụng cũ mà bạn không sử dụng, sứ mệnh của FRESHME sẽ là đưa nó đến những người thực sự cần. Mọi đóng góp của bạn có thể góp phần giúp đỡ trẻ em nghèo và gia đình của các em có được sự bảo vệ, chăm sóc sức khỏe và giáo dục quan trọng.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Gap(20),
                            Center(
                              child: SizedBox(
                                width: 200,
                                child: DottedButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const HomeScreen())),
                                  child: const Text('Signup Now'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashOrbit extends StatefulWidget {
  const SplashOrbit({super.key});

  @override
  State<SplashOrbit> createState() => _SplashOrbitState();
}

class _SplashOrbitState extends State<SplashOrbit> {
  TimelineTween<_CircleProps> _circleTween(double maxWidth) =>
      TimelineTween<_CircleProps>()
        ..addScene(
          begin: 0.ms,
          end: 300.ms,
          curve: Curves.ease,
        )
            .animate(
              _CircleProps.rotate,
              curve: Curves.easeInCirc,
              tween: Tween<double>(begin: -pi, end: 0),
            )
            .animate(
              _CircleProps.innerSize,
              tween: Tween<double>(begin: 0, end: 150 * maxWidth / 300),
            )
            .animate(
              _CircleProps.outterSide,
              tween: Tween<double>(begin: 0, end: 200 * maxWidth / 300),
            );

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
          color: Colors.amber.shade200,
          image: Images.environmentProtection,
          offset: const Offset(260, 120),
        ),
        _Orbit(
          size: 65.0,
          color: Colors.red.shade200,
          image: Images.foodDonation,
          offset: const Offset(-27, 100),
        ),
        _Orbit(
          size: 55.0,
          color: Colors.blue.shade200,
          image: Images.giveLove,
          offset: const Offset(145, 255),
        ),
        _Orbit(
          size: 70.0,
          color: Colors.green.shade200,
          image: Images.historyBook,
          offset: const Offset(120, -30),
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
              return SizedBox(
                height: constraints.maxWidth,
                width: constraints.maxWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: SizedBox(
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                        child: LoopAnimation<TimelineValue<_OrbitProps>>(
                          tween: _orbitTween,
                          duration: 3000.seconds,
                          builder: (context, child, value) => Transform.rotate(
                            angle: value.get(_OrbitProps.rotate),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: PlayAnimation<double>(
                                    tween: Tween(
                                      begin: 0.0,
                                      end: 250.0 / 300 * constraints.maxWidth,
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
                                    scale: 1.2,
                                    child: PlayAnimation<double>(
                                      tween: Tween(
                                        begin: 0.0,
                                        end: 250.0 / 300 * constraints.maxWidth,
                                      ),
                                      duration: 300.ms,
                                      curve: Curves.ease,
                                      builder: (context, child, value) =>
                                          DottedBorder(
                                        borderType: BorderType.Circle,
                                        dashPattern: const [30, 10],
                                        strokeWidth: 1.5,
                                        color: Colors.black12,
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
                                    scale: 1.4,
                                    child: PlayAnimation<double>(
                                      tween: Tween(
                                        begin: 0.0,
                                        end: 250.0 / 300 * constraints.maxWidth,
                                      ),
                                      duration: 300.ms,
                                      curve: Curves.ease,
                                      builder: (context, child, value) =>
                                          DottedBorder(
                                        borderType: BorderType.Circle,
                                        dashPattern: const [30, 10],
                                        strokeWidth: 1,
                                        color: Colors.black12,
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
                                    left: orbit.offset.dx *
                                        constraints.maxWidth /
                                        300,
                                    top: orbit.offset.dy *
                                        constraints.maxWidth /
                                        300,
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
                                            height: orbit.size *
                                                constraints.maxWidth /
                                                300,
                                            width: orbit.size *
                                                constraints.maxWidth /
                                                300,
                                            decoration: BoxDecoration(
                                              color: orbit.color,
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              height: 30 *
                                                  constraints.maxWidth /
                                                  300,
                                              width: 30 *
                                                  constraints.maxWidth /
                                                  300,
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
                      child: _circleImage(constraints.maxWidth),
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
    return SizedBox(
      height: 200 * maxWidth / 300,
      width: 200 * maxWidth / 300,
      child: PlayAnimation<TimelineValue<_CircleProps>>(
        tween: _circleTween(maxWidth),
        duration: 300.ms,
        builder: (context, child, value) => Transform.rotate(
          angle: value.get(_CircleProps.rotate),
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: value.get(_CircleProps.outterSide),
                  width: value.get(_CircleProps.outterSide),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(width: 2),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: value.get(_CircleProps.innerSize),
                  width: value.get(_CircleProps.innerSize),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(width: 2),
                    image: const DecorationImage(
                      image: AssetImage(
                        Images.volunteerHandingDonationBox,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
