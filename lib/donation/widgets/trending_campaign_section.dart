import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/campaign_detail/model/_default.dart';
import 'package:freshme/_internal/domain/campaign/campaign_target.dart';
import 'package:freshme/campaign_detail/widgets/campaign_organization_text.dart';
import 'package:freshme/donation/dependencies.dart';
import 'package:freshme/_internal/presentation/fresh_widget/fresh_frame.dart';

class TrendingCampaignSection extends ConsumerWidget {
  const TrendingCampaignSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Campaign',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              FreshTextButton(
                onPressed: () {},
                text: 'See All',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            children: [
              for (int index = 0; index < 4; index++)
                _campaignCard(context, ref, index),
            ],
          ),
        ),
      ],
    );
  }

  Widget _campaignCard(BuildContext context, WidgetRef ref, int index) {
    final campaignFuture = ref.read(fetchCampaignProvider(index.toString()));
    final campaign = campaignFuture.mapOrNull(
      data: (data) => data.value.mapOrNull((value) => value),
    );

    if (campaign == null) {
      return AspectRatio(
        aspectRatio: 1.4,
        child: Container(
          height: 220,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    final campaignCardWidget = CampaignCard(
      angle: index % 2 == 0 ? FreshAngle.right : FreshAngle.left,
      image: campaign.thumbnails.first,
      category: campaign.categories.first.name,
      title: campaign.name,
      subtitle: CampaignOrganizationText(
        campaign.orgId,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),
      ),
      finishedGoal: campaign.target.finishedGoal,
      onTap: () async {
        final page = MaterialPageRoute(
          builder: (_) => const CampaignPage(id: '0'),
        );
        Navigator.push(context, page);
      },
    );

    if (index == 3) {
      return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: campaignCardWidget,
      );
    } else if (index == 0) {
      return Padding(
        padding: const EdgeInsets.only(right: 15),
        child: campaignCardWidget,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: campaignCardWidget,
      );
    }
  }
}
