import 'package:community_material_icon/community_material_icon.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/campaign_detail/model/donate_campaign.dart';
import 'package:freshme/campaign_detail/widgets/campaign_organization_text.dart';
import 'package:freshme/fresh_widget/fresh_carousel.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/fresh_widget/fresh_progress_bar.dart';
import 'package:gap/gap.dart';

class CampaignHeader extends ConsumerWidget {
  const CampaignHeader(this.campaign, {super.key});

  final DonateCampaignData campaign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            FreshCarousel(imageUrls: campaign.thumbnails),
            const Gap(30),
            Text(
              campaign.name,
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
                letterSpacing: 1.3,
                wordSpacing: 2,
              ),
            ),
            const Gap(12),
            CampaignOrganizationText(campaign.orgId),
            const Gap(16),
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
            const Gap(30),
            const FreshProgressBar(
              percent: 0.6,
              direction: Axis.horizontal,
              length: double.maxFinite,
              thickness: 20,
            ),
            const Gap(12),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
