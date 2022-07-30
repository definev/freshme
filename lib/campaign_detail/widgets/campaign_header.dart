import 'package:community_material_icon/community_material_icon.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/campaign_detail/model/campaign_target.dart';
import 'package:freshme/campaign_detail/model/donate_campaign.dart';
import 'package:freshme/campaign_detail/widgets/campaign_organization_text.dart';
import 'package:freshme/campaign_detail/widgets/campaign_target_widget.dart';
import 'package:freshme/fresh_widget/color_gap.dart';
import 'package:freshme/fresh_widget/fresh_carousel.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/fresh_widget/fresh_progress_bar.dart';
import 'package:gap/gap.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CampaignHeader extends ConsumerWidget {
  const CampaignHeader(this.campaign, {super.key});

  final DonateCampaignData campaign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return MultiSliver(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: FreshCarousel(imageUrls: [
            ...campaign.thumbnails,
            ...campaign.thumbnails,
          ]),
        ),
        const Gap(18),
        SliverPinnedHeader(
          child: ColorGap(
            backgroundColor: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.name,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: 1.3,
                      wordSpacing: 2,
                    ),
                  ),
                  const Gap(6),
                  CampaignOrganizationText(campaign.orgId),
                  const Gap(6),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SeparatedRow(
                        separatorBuilder: () => const Gap(8),
                        children: campaign.categories
                            .map(
                              (e) => FreshChip(
                                onPressed: () {},
                                color: e.color,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(
                        CommunityMaterialIcons.map_marker_outline,
                        size: 18,
                      ),
                      const Gap(4),
                      Text(
                        campaign.location,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SliverPinnedHeader(
          child: ColoredBox(
            color: theme.scaffoldBackgroundColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Gap(6),
                      FreshProgressBar(
                        percent: campaign.target.finishedGoal,
                        direction: Axis.horizontal,
                        length: double.maxFinite,
                        thickness: 20,
                      ),
                      const Gap(12),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        const Gap(6),
        SeparatedColumn(
          separatorBuilder: () => const Divider(height: 1),
          children: campaign //
              .target
              .list
              .map<Widget>(CampaignTargetWidget.new)
              .toList(),
        ),
        const Gap(12),
        const Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.black87,
        ),
        const Gap(12),
      ],
    );
  }
}
