import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freshme/campaign_detail/model/single_target.dart';

part 'campaign_target.freezed.dart';
part 'campaign_target.g.dart';

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
              between: (b) => b.lessThan,
            ),
      );
}
