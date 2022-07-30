import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:freshme/donation/widgets/donation_actions.dart';
import 'package:freshme/donation/widgets/trending_campaign_section.dart';
import 'package:freshme/donation/widgets/donation_app_bar.dart';
import 'package:freshme/donation/widgets/donation_header.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            MultiSliver(children: const [DonationAppBar()]),
            MultiSliver(
              children: const [
                DonationHeader(),
                PaddedColumn(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 64),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DonationActions(),
                    TrendingCampaignSection(),
                    // TrendingCampaignSection(),
                    // TrendingCampaignSection(),
                    // TrendingCampaignSection(),
                    // TrendingCampaignSection(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
