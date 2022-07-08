import 'package:freshme/campaign_detail/model/_default.dart';
import 'package:freshme/campaign_detail/model/donate_campaign.dart';
import 'package:riverpod/riverpod.dart';

final campaignControllerProvider = StateNotifierProvider //
    .family<CampaignController, DonateCampaign, String>(
  (ref, campaignId) {
    final fetchCampaign = ref.watch(fetchCampaignProvider(campaignId));

    final campaign = fetchCampaign.map(
      data: (data) => data.value,
      loading: (_) => const DonateCampaign.loading(),
      error: (error) => DonateCampaign.error(error.toString()),
    );

    return CampaignController(campaign);
  },
);

class CampaignController extends StateNotifier<DonateCampaign> {
  CampaignController(DonateCampaign campaign) : super(campaign);
}
