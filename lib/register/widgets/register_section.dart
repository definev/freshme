import 'package:animations/animations.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/register/widgets/sign_in_section.dart';
import 'package:freshme/register/widgets/sign_up_section.dart';
import 'package:freshme/register/widgets/splash_section.dart';

enum RegisterSectionState {
  splash,
  signUp,
  signIn;

  Widget get widget {
    switch (this) {
      case RegisterSectionState.splash:
        return const SplashSection();
      case RegisterSectionState.signUp:
        return const SignUpSection();
      case RegisterSectionState.signIn:
        return const SignInSection();
    }
  }
}

final registerSectionProvider = StateProvider.autoDispose<RegisterSectionState>(
  (ref) => RegisterSectionState.splash,
);

class RegisterSection extends ConsumerWidget {
  const RegisterSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(registerSectionProvider);

    return Container(
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
            offset: const Offset(0, 10),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        ],
        color: Colors.white,
      ),
      child: AnimatedSwitcher(
        duration: 1200.ms,
        switchInCurve: Curves.ease,
        transitionBuilder: (child, animation) => FadeThroughTransition(
          animation: animation,
          secondaryAnimation: ReverseAnimation(animation),
          child: child,
        ),
        child: section.widget,
      ),
    );
  }
}
