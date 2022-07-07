import 'package:flutter/material.dart';
import 'package:freshme/donation/dependencies.dart';
import 'package:gap/gap.dart';

class DonationHeader extends StatelessWidget {
  const DonationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Let\'s share goodness',
          style: Theme.of(context) //
              .textTheme
              .titleLarge!
              .copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
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
        const Gap(15),
        const FreshSearchBox(),
        const Gap(20),
      ],
    );
  }
}
