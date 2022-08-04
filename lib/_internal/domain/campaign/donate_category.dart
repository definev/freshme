import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'donate_category.freezed.dart';
part 'donate_category.g.dart';

@freezed
class DonateCategory with _$DonateCategory {
  @JsonSerializable(fieldRename: FieldRename.snake)
  @ColorConverter()
  const factory DonateCategory(
    String id, {
    required String name,
    required Color color,
  }) = _DonateCategory;

  factory DonateCategory.fromJson(Map<String, dynamic> json) =>
      _$DonateCategoryFromJson(json);
}

class ColorConverter extends JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return Color(int.parse(json));
  }

  @override
  String toJson(Color object) {
    return object.value.toString();
  }
}
