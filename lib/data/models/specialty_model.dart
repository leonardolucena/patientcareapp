import 'package:flutter/material.dart';

class SpecialtyModel {
  final String id;
  final String nameKey; // Key para i18n (ex: 'cardiology')
  final IconData icon;

  const SpecialtyModel({
    required this.id,
    required this.nameKey,
    required this.icon,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      icon: IconData(
        json['iconCodePoint'] as int,
        fontFamily: 'MaterialIcons',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'iconCodePoint': icon.codePoint,
    };
  }

  SpecialtyModel copyWith({
    String? id,
    String? nameKey,
    IconData? icon,
  }) {
    return SpecialtyModel(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpecialtyModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

