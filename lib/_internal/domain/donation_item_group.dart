import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_item_group.freezed.dart';
part 'donation_item_group.g.dart';

@freezed
class DonationItemGroup with _$DonationItemGroup {
  @JsonSerializable()
  const factory DonationItemGroup({
    required String id,
    required String imageUrl,
    required List<DonationItem> items,
  }) = _DonationItemGroup;

  factory DonationItemGroup.fromJson(Map<String, dynamic> json) =>
      _$DonationItemGroupFromJson(json);
}

@freezed
class DonationItem with _$DonationItem {
  @JsonSerializable()
  const factory DonationItem({
    required String id,
    required String name,
    @RectJsonConverter() required Rect boundingBox,
  }) = _DonationItem;

  factory DonationItem.fromJson(Map<String, dynamic> json) =>
      _$DonationItemFromJson(json);
}

class RectJsonConverter extends JsonConverter<Rect, Map<String, dynamic>> {
  const RectJsonConverter();

  @override
  Rect fromJson(Map<String, dynamic> json) {
    return Rect.fromLTRB(
      json['left'],
      json['top'],
      json['right'],
      json['bottom'],
    );
  }

  @override
  Map<String, dynamic> toJson(Rect object) {
    return {
      'left': object.left,
      'top': object.top,
      'right': object.right,
      'bottom': object.bottom,
    };
  }
}
