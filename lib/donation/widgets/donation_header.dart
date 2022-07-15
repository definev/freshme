import 'package:flutter/material.dart';
import 'package:freshme/donation/dependencies.dart';
import 'package:freshme/fresh_widget/color_gap.dart';
import 'package:gap/gap.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DonationHeader extends StatelessWidget {
  const DonationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiSliver(
      children: [
        SliverPinnedHeader(
          child: ColorGap(
            backgroundColor: theme.scaffoldBackgroundColor,
            child: Column(
              children: [
                const Gap(12),
                Center(
                  child: Text(
                    'Let\'s share goodness',
                    style: Theme.of(context) //
                        .textTheme
                        .titleLarge!
                        .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Gap(12),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Good people help each other',
              style: Theme.of(context) //
                  .textTheme
                  .bodySmall!
                  .copyWith(
                    fontWeight: FontWeight.w200,
                  ),
            ),
          ),
        ),
        const Gap(6),
        SliverPinnedHeader(
          child: ColoredBox(
            color: theme.scaffoldBackgroundColor,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: FreshSearchBox(),
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
