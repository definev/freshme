import 'package:flutter/material.dart';
import 'package:freshme/donation/dependencies.dart';
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
          child: ColoredBox(
            color: theme.scaffoldBackgroundColor,
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
              ],
            ),
          ),
        ),
        Column(
          children: [
            const Gap(12),
            Text(
              'Good people help each other',
              style: Theme.of(context) //
                  .textTheme
                  .bodySmall!
                  .copyWith(
                    fontWeight: FontWeight.w200,
                  ),
            ),
          ],
        ),
        SliverPinnedHeader(
          child: ColoredBox(
            color: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: const FreshSearchBox(),
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
