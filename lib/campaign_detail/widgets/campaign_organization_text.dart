import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/campaign_detail/model/campaign_organization.dart';

class CampaignOrganizationText extends ConsumerWidget {
  const CampaignOrganizationText(
    this.orgId, {
    super.key,
    this.style,
  });

  final String orgId;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campOrg = ref.watch(fetchCampaignOrganization(orgId));

    return campOrg.when(
      loading: () => const SizedBox(),
      error: (e, st) => const SizedBox(),
      data: (value) => value == null
          ? const SizedBox()
          : Text(
              value.name,
              style: style,
            ),
    );
  }
}
