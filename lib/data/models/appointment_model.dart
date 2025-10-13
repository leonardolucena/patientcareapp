class AppointmentModel {
  final String id;
  final String doctorId;
  final String clinicId;
  final String patientId;
  final String consultationType; // 'online' or 'inPerson'
  final DateTime dateTime;
  final String priority; // 'normal' or 'urgent'
  final String paymentMethod; // 'cash' or 'creditCard'
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String price;

  const AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.clinicId,
    required this.patientId,
    required this.consultationType,
    required this.dateTime,
    required this.priority,
    required this.paymentMethod,
    this.status = 'scheduled',
    required this.price,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      clinicId: json['clinicId'] as String,
      patientId: json['patientId'] as String,
      consultationType: json['consultationType'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      priority: json['priority'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String? ?? 'scheduled',
      price: json['price'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'patientId': patientId,
      'consultationType': consultationType,
      'dateTime': dateTime.toIso8601String(),
      'priority': priority,
      'paymentMethod': paymentMethod,
      'status': status,
      'price': price,
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? doctorId,
    String? clinicId,
    String? patientId,
    String? consultationType,
    DateTime? dateTime,
    String? priority,
    String? paymentMethod,
    String? status,
    String? price,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      clinicId: clinicId ?? this.clinicId,
      patientId: patientId ?? this.patientId,
      consultationType: consultationType ?? this.consultationType,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      price: price ?? this.price,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointmentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

