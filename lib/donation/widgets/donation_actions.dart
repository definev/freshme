import 'package:flutter/material.dart';
import 'package:freshme/donation/dependencies.dart';

class DonationActions extends StatelessWidget {
  const DonationActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DonationActionTile(
          color: const Color(0xFFbfdadd),
          image: Image.asset(Images.donation),
          title: 'Donations',
          onPressed: () {},
        ),
        DonationActionTile(
          color: const Color(0xFFFFD5C9),
          image: Image.asset(Images.photoCamera),
          title: 'Send your love',
          isCenter: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CameraPage(),
              ),
            );
          },
        ),
        DonationActionTile(
          color: const Color(0xFFfde387).withOpacity(0.3),
          image: Image.asset(Images.cardboard),
          title: 'Raise Funds',
          onPressed: () {},
        ),
      ],
    );
  }
}
