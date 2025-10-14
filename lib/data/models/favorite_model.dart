import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  final String id;
  final String itemId;
  final String itemType; // 'doctor' ou 'clinic'
  final DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          itemId == other.itemId &&
          itemType == other.itemType;

  @override
  int get hashCode => id.hashCode ^ itemId.hashCode ^ itemType.hashCode;
}
