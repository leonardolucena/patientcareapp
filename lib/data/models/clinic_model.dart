class ClinicModel {
  final String id;
  final String name;
  final String address;
  final String distance;
  final double latitude;
  final double longitude;

  const ClinicModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      distance: json['distance'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  ClinicModel copyWith({
    String? id,
    String? name,
    String? address,
    String? distance,
    double? latitude,
    double? longitude,
  }) {
    return ClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClinicModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

