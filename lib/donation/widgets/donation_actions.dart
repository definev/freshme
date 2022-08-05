import 'package:flutter/material.dart';
import 'package:freshme/donation/dependencies.dart';
import 'package:freshme/donation_items/donation_items_page.dart';
import 'package:freshme/home/home_screen.dart';

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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DonationItemsPage()),
          ),
        ),
        DonationActionTile(
          color: const Color(0xFFFFD5C9),
          image: Image.asset(Images.photoCamera),
          title: 'Send your love',
          isCenter: true,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                    return false;
                  },
                  child: const CameraPage(),
                ),
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
