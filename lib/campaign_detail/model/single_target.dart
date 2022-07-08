import 'package:freezed_annotation/freezed_annotation.dart';
import 'personal_donate.dart';

part 'single_target.freezed.dart';
part 'single_target.g.dart';

@freezed
class SingleTarget with _$SingleTarget {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SingleTarget.exact({
    required TargetResource resource,
    required String name,
    required String unit,
    required int goal,
    @Default(0) int currentValue,
  }) = _ExactSingleTarget;

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SingleTarget.minimum({
    required TargetResource resource,
    required String name,
    required String unit,
    required int goal,
    @Default(0) int currentValue,
  }) = _MinimumSingleTarget;

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SingleTarget.between({
    required TargetResource resource,
    required String name,
    required String unit,
    required int greaterThan,
    required int lowerThan,
    @Default(0) int currentValue,
  }) = _BetweenSingleTarget;

  factory SingleTarget.fromJson(Map<String, dynamic> json) =>
      _$SingleTargetFromJson(json);

  static bool softCompare(SingleTarget target, SingleTarget other) {
    if (target.resource != other.resource) return false;
    if (target.name != other.name) return false;
    return true;
  }
}

@freezed
class SingleTargetUnit with _$SingleTargetUnit {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SingleTargetUnit(
    SingleTarget target, {
    required int unit,
  }) = _SingleTargetUnit;

  factory SingleTargetUnit.fromJson(Map<String, dynamic> json) =>
      _$SingleTargetUnitFromJson(json);
}
