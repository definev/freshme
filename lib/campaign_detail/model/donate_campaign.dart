import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freshme/campaign_detail/model/campaign_target.dart';
import 'package:freshme/campaign_detail/model/donate_category.dart';

part 'donate_campaign.freezed.dart';
part 'donate_campaign.g.dart';

@freezed
class DonateCampaign with _$DonateCampaign {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DonateCampaign({
    required String id,
    required String orgId,
    required String name,
    required List<String> thumbnails,
    required String location,
    required String content,
    required List<DonateCategory> categories,
    required CampaignTarget target,
  }) = DonateCampaignData;

  const factory DonateCampaign.loading() = _Loading;
  const factory DonateCampaign.error(String error) = _Error;

  factory DonateCampaign.fromJson(Map<String, dynamic> json) =>
      _$DonateCampaignFromJson(json);
}
