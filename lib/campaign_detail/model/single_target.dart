import 'package:freezed_annotation/freezed_annotation.dart';
import 'personal_donate.dart';

part 'single_target.freezed.dart';
part 'single_target.g.dart';

@freezed
class TargetDetail with _$TargetDetail {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TargetDetail({
    required TargetResource resource,
    required String name,
    required String unit,
  }) = _TargetDetail;

  factory TargetDetail.fromJson(Map<String, dynamic> json) =>
      _$TargetDetailFromJson(json);
}

@freezed
class SingleTarget with _$SingleTarget {
  const SingleTarget._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SingleTarget.exact({
    required TargetDetail detail,
    required int goal,
    @Default(0) int currentValue,
  }) = _ExactSingleTarget;

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SingleTarget.minimum({
    required TargetDetail detail,
    required int goal,
    @Default(0) int currentValue,
  }) = _MinimumSingleTarget;

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SingleTarget.between({
    required TargetDetail detail,
    required int greaterThan,
    required int lessThan,
    @Default(0) int currentValue,
  }) = _BetweenSingleTarget;

  factory SingleTarget.fromJson(Map<String, dynamic> json) =>
      _$SingleTargetFromJson(json);

  static bool softCompare(SingleTarget target, SingleTarget other) {
    if (target.detail.resource != other.detail.resource) return false;
    if (target.detail.name != other.detail.name) return false;
    if (target.detail.unit != other.detail.unit) return false;
    return true;
  }

  int? get limitNeeded => map(
        exact: (exact) => exact.goal - exact.currentValue,
        minimum: (minimum) => null,
        between: (between) => between.lessThan - between.currentValue,
      );
}

@freezed
class TargetUnit with _$TargetUnit {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TargetUnit(
    TargetDetail detail, {
    required int unit,
    int? limit,
  }) = _SingleTargetUnit;

  factory TargetUnit.fromJson(Map<String, dynamic> json) =>
      _$TargetUnitFromJson(json);
}
