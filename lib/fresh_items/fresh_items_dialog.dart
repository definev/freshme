import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/num_duration_extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freshme/fresh_widget/dotted_button.dart';
import 'package:freshme/fresh_widget/fresh_frame.dart';
import 'package:gap/gap.dart';

enum _DonateType { people, item }

class FreshItemsDialog extends HookWidget {
  const FreshItemsDialog(this.prevContext, {super.key});

  final BuildContext prevContext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final md = MediaQuery.of(prevContext);

    final expanded = useState(false);
    final donateType = useState<_DonateType?>(null);

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox.expand(
              child: ColoredBox(color: Colors.transparent),
            ),
          ),
        ),
        AnimatedContainer(
          duration: 300.ms,
          curve: Curves.ease,
          constraints: BoxConstraints.tightFor(
            height: expanded.value ? 500 - md.viewPadding.vertical : 340,
          ),
          child: ColoredBox(
            color: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Ủng hộ',
                    style: theme //
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(20),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: 150.ms,
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: _buildContentView(
                        theme,
                        donateType: donateType,
                        expanded: expanded,
                      ),
                    ),
                  ),
                  const Gap(30),
                  FreshDottedButton(
                    outterColor: theme.colorScheme.error,
                    innerColor: theme.colorScheme.error,
                    outterBordered: false,
                    child: const Text('Hủy'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentView(
    ThemeData theme, {
    required ValueNotifier<bool> expanded,
    required ValueNotifier<_DonateType?> donateType,
  }) {
    switch (donateType.value) {
      case _DonateType.item:
        return const SizedBox();
      case _DonateType.people:
        return Column(
          children: const [
            Text(''),
          ],
        );
      case null:
        return Row(
          children: [
            Expanded(
              child: _DonateTypeChoiceCard(
                icon: CommunityMaterialIcons.head,
                onPressed: () {
                  expanded.value = true;
                  donateType.value = _DonateType.people;
                },
                title: 'Ủng hộ sức người',
              ),
            ),
            const Gap(25),
            Expanded(
              child: _DonateTypeChoiceCard(
                icon: Icons.inventory,
                onPressed: () {
                  expanded.value = true;
                  donateType.value = _DonateType.item;
                },
                title: 'Ủng hộ hiện vật',
              ),
            ),
          ],
        );
    }
  }
}

class _DonateTypeChoiceCard extends StatelessWidget {
  const _DonateTypeChoiceCard({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FreshFrame(
      angle: FreshAngle.balance,
      padding: EdgeInsets.zero,
      noise: 0.09,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(),
          shadowColor: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: theme.colorScheme.primary,
            ),
            const Gap(16),
            Center(child: Text(title)),
          ],
        ),
      ),
    );
  }
}
