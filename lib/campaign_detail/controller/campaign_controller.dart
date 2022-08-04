import 'package:freshme/_internal/domain/campaign/donate_campaign.dart';
import 'package:freshme/backend_simulator/campaign_server.dart';
import 'package:riverpod/riverpod.dart';

final fetchCampaignProvider =
    FutureProvider.family<DonateCampaign, String>((ref, campaignId) {
  final server = ref.watch(campaignServerProvider);
  return server.getCampaign(campaignId);
});

final campaignControllerProvider = StateNotifierProvider //
    .family<CampaignController, AsyncValue<DonateCampaign>, String>(
  (ref, campaignId) {
    final fetchCampaign = ref.watch(fetchCampaignProvider(campaignId));

    final campaign = fetchCampaign.map<AsyncValue<DonateCampaign>>(
      data: (data) => AsyncValue.data(data.value),
      error: (error) => AsyncValue.error(error.toString()),
      loading: (_) => const AsyncValue.loading(),
    );

    return CampaignController(campaign);
  },
);

class CampaignController extends StateNotifier<AsyncValue<DonateCampaign>> {
  CampaignController(AsyncValue<DonateCampaign> campaign) : super(campaign);
}
