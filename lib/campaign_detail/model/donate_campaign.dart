import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freshme/campaign_detail/model/single_target.dart';

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
    required List<String> categories,
    required CampaignTarget target,
  }) = _DonateCampaign;

  const factory DonateCampaign.loading() = _Loading;
  const factory DonateCampaign.error(String error) = _Error;

  factory DonateCampaign.fromJson(Map<String, dynamic> json) =>
      _$DonateCampaignFromJson(json);
}

@freezed
class CampaignTarget with _$CampaignTarget {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CampaignTarget(List<SingleTarget> list) = _CampaignTarget;

  factory CampaignTarget.fromJson(Map<String, dynamic> json) =>
      _$CampaignTargetFromJson(json);
}

extension CampaignTargetMethod on CampaignTarget {
  double get finishedGoal =>
      list.fold<double>(
        0,
        (sum, target) => sum + target.currentValue,
      ) /
      list.fold<double>(
        0,
        (total, target) =>
            total +
            target.map(
              exact: (e) => e.goal,
              minimum: (m) => m.goal,
              between: (b) => b.lowerThan,
            ),
      );
}
