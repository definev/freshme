import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/fresh_widget/fresh_dotted_button.dart';
import 'package:freshme/fresh_widget/fresh_text_field.dart';
import 'package:freshme/register/widgets/register_section.dart';
import 'package:gap/gap.dart';

class SignUpSection extends ConsumerWidget {
  const SignUpSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        children: [
          Text(
            'Sign up with email',
            style: theme //
                .textTheme
                .bodyLarge!
                .copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          const FreshTextField(
            hintText: 'Email',
            borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 12, cornerSmoothing: 0.6)),
          ),
          const Gap(12),
          const FreshTextField(
            hintText: 'Password',
            borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 12, cornerSmoothing: 0.6)),
            obscureText: true,
          ),
          const Gap(20),
          FreshDottedButton(
            radius: 12,
            outterBordered: false,
            innerColor: theme.colorScheme.primary,
            child: Text(
              'Sign up',
              style: theme //
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: theme.colorScheme.onPrimary),
            ),
            onPressed: () {},
          ),
          const Gap(16),
          Text(
            'OR',
            style: theme //
                .textTheme
                .bodyLarge!
                .copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          FreshDottedButton(
            radius: 12,
            outterBordered: false,
            innerColor: theme.colorScheme.secondary,
            outterColor: theme.colorScheme.primary,
            child: Text(
              'Sign in',
              style: theme //
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: theme.colorScheme.onSecondary),
            ),
            onPressed: () => ref //
                .read(registerSectionProvider.notifier)
                .state = RegisterSectionState.signIn,
          ),
        ],
      ),
    );
  }
}
