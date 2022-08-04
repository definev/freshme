import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freshme/campaign_detail/repository/campaign_organization_remote.dart';

part 'campaign_organization.freezed.dart';
part 'campaign_organization.g.dart';

final fetchCampaignOrganization = FutureProvider //
    .family<CampaignOrganization?, String>(
  (ref, id) => ref //
      .read(campaignOrganizationRemote)
      .getCampaignOrganization(id),
);

@freezed
class CampaignOrganization with _$CampaignOrganization {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CampaignOrganization(
    String id, {
    required String name,
  }) = _CampaignOrganization;

  factory CampaignOrganization.fromJson(Map<String, dynamic> json) =>
      _$CampaignOrganizationFromJson(json);
}
