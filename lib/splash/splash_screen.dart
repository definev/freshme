import 'package:community_material_icon/community_material_icon.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freshme/fresh_widget/dotted_button.dart';
import 'package:freshme/home/home_screen.dart';
import 'package:freshme/splash/splash_orbit.dart';
import 'package:gap/gap.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: const SplashOrbit().animate().fadeIn(),
            ),
            Expanded(
              flex: 5,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: const _BottomSplashContainer() //
                          .animate()
                          .move(),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(32, 16, 32, 110),
                          padding: const EdgeInsets.all(20),
                          decoration: ShapeDecoration(
                            shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.all(
                                SmoothRadius(
                                  cornerRadius: 40,
                                  cornerSmoothing: 1,
                                ),
                              ),
                              side: BorderSide(width: 2),
                            ),
                            shadows: [
                              BoxShadow(
                                blurRadius: 10,
                                offset: Offset(0, 10),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                              ),
                            ],
                            color: Colors.white,
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
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ) //
                                        .animate()
                                        .fade(duration: 500.ms),
                                    const Gap(20),
                                    const Text(
                                      'Hãy ủng hộ FRESHME, cung cấp những vật dụng cũ mà bạn không sử dụng, sứ mệnh của FRESHME sẽ là đưa nó đến những người thực sự cần. Mọi đóng góp của bạn có thể góp phần giúp đỡ trẻ em nghèo và gia đình của các em có được sự bảo vệ, chăm sóc sức khỏe và giáo dục quan trọng.',
                                      textAlign: TextAlign.center,
                                    ) //
                                        .animate()
                                        .fade(duration: 500.ms),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Center(
                                child: SizedBox(
                                  width: 200,
                                  child: FreshDottedButton(
                                    radius: 15,
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                    ),
                                    child: const Text('Signup Now'),
                                  ),
                                ) //ƒ
                                    .animate()
                                    .fade(duration: 500.ms),
                              ),
                            ],
                          ),
                        ) //
                            .animate()
                            .move(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSplashContainer extends StatelessWidget {
  const _BottomSplashContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(
              cornerRadius: 35,
              cornerSmoothing: 1,
            ),
          ),
          side: BorderSide(width: 2),
        ),
        color: Colors.green.shade200,
      ),
      width: double.maxFinite,
      height: 200,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SeparatedRow(
            separatorBuilder: () => const Gap(20),
            children: AnimateList(
              effects: [
                const FadeEffect(),
                const MoveEffect(),
              ],
              children: [
                Expanded(
                  child: _SocialButton(
                    isLarge: constraints.maxWidth > 400,
                    icon: CommunityMaterialIcons.google,
                    name: 'Google',
                    color: const Color(0xFFc43f30),
                  ),
                ),
                Expanded(
                  child: _SocialButton(
                    isLarge: constraints.maxWidth > 400,
                    icon: CommunityMaterialIcons.facebook,
                    name: 'Facebook',
                    color: const Color(0xFF3b63ad),
                  ),
                ),
                Expanded(
                  child: _SocialButton(
                    isLarge: constraints.maxWidth > 400,
                    icon: CommunityMaterialIcons.apple,
                    name: 'Apple',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    Key? key,
    required this.isLarge,
    required this.color,
    required this.name,
    required this.icon,
  }) : super(key: key);

  final bool isLarge;
  final Color color;
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FreshDottedButton(
      radius: 15,
      outterColor: color,
      innerBorderColor: color,
      outterBordered: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
          ),
          if (isLarge) ...[
            const Gap(10),
            Text(name),
          ],
        ],
      ),
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      ),
    );
  }
}
