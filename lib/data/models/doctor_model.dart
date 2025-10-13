class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String experience;
  final String price;
  final String image;
  final int patientsCount;
  final String country;
  final String location;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.price,
    required this.image,
    this.patientsCount = 0,
    this.country = 'Brasil',
    this.location = 'Av. Paulista, 1000 - São Paulo, SP',
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      rating: (json['rating'] as num).toDouble(),
      experience: json['experience'] as String,
      price: json['price'] as String,
      image: json['image'] as String,
      patientsCount: json['patientsCount'] as int? ?? 0,
      country: json['country'] as String? ?? 'Brasil',
      location: json['location'] as String? ?? 'Av. Paulista, 1000 - São Paulo, SP',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'experience': experience,
      'price': price,
      'image': image,
      'patientsCount': patientsCount,
      'country': country,
      'location': location,
    };
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    double? rating,
    String? experience,
    String? price,
    String? image,
    int? patientsCount,
    String? country,
    String? location,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      price: price ?? this.price,
      image: image ?? this.image,
      patientsCount: patientsCount ?? this.patientsCount,
      country: country ?? this.country,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

