import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:freshme/donation/widgets/donation_actions.dart';
import 'package:freshme/donation/widgets/trending_campaign_section.dart';
import 'package:freshme/donation/widgets/donation_app_bar.dart';
import 'package:freshme/donation/widgets/donation_header.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: const [
            DonationAppBar(),
            PaddedColumn(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 64),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DonationHeader(),
                DonationActions(),
                TrendingCampaignSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
