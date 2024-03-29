import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freshme/_internal/domain/campaign/campaign_target.dart';
import 'package:freshme/_internal/domain/campaign/donate_category.dart';

part 'donate_campaign.freezed.dart';
part 'donate_campaign.g.dart';

@freezed
class DonateCampaign with _$DonateCampaign {
  @JsonSerializable()
  const factory DonateCampaign({
    required String id,
    required String orgId,
    required String name,
    required List<String> thumbnails,
    required String location,
    required String content,
    required List<DonateCategory> categories,
    required CampaignTarget target,
  }) = _DonateCampaignData;

  factory DonateCampaign.fromJson(Map<String, dynamic> json) =>
      _$DonateCampaignFromJson(json);
}
