import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freshme/campaign_detail/model/single_target.dart';

part 'personal_donate.freezed.dart';
part 'personal_donate.g.dart';

enum TargetResource { people, item }

@freezed
class PersonalDonate with _$PersonalDonate {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PersonalDonate(List<TargetUnit> targetUnits) =
      _PersonalDonate;

  factory PersonalDonate.fromJson(Map<String, dynamic> json) =>
      _$PersonalDonateFromJson(json);
}
