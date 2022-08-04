import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/domain/campaign/campaign_organization.dart';

final campaignOrganizationRemote = Provider<CampaignOrganizationRemote>(
  (_) => CampaignOrganizationRemoteImpl(),
);

abstract class CampaignOrganizationRemote {
  Future<CampaignOrganization?> getCampaignOrganization(String id);
}

class CampaignOrganizationRemoteImpl implements CampaignOrganizationRemote {
  @override
  Future<CampaignOrganization?> getCampaignOrganization(String id) async {
    return CampaignOrganization(id, name: 'THPT Hàn Thuyên');
  }
}
