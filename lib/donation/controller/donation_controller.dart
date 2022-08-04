import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/domain/campaign/donate_campaign.dart';
import 'package:freshme/backend_simulator/campaign_server.dart';

const kCampaignPerPage = 4;

class DonationController {
  static final donateCampaignsProvider =
      FutureProvider.family<List<DonateCampaign>, int>((ref, page) {
    final server = ref.watch(campaignServerProvider);
    return server.getCampaignsByPage(page, kCampaignPerPage);
  });

  static final donateCampaignCountProvider = FutureProvider<int>(
    (ref) {
      final server = ref.watch(campaignServerProvider);
      return server.getCampaignsCount();
    },
  );
}
