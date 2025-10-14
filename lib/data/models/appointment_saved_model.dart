import 'package:hive/hive.dart';

part 'appointment_saved_model.g.dart';

/// Model para agendamentos salvos localmente no Hive
/// 
/// Representa um agendamento criado pelo usuário
@HiveType(typeId: 1)
class AppointmentSavedModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String doctorName;

  @HiveField(2)
  final String specialty;

  @HiveField(3)
  final String clinicName;

  @HiveField(4)
  final String consultationType; // Online ou Presencial

  @HiveField(5)
  final String date; // Data formatada (ex: 15/11/2024)

  @HiveField(6)
  final String time; // Horário (ex: 10:00)

  @HiveField(7)
  final String priority; // Normal ou Urgência

  @HiveField(8)
  final String paymentMethod; // Dinheiro ou Cartão de crédito

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final bool isCompleted; // true = fechado, false = aberto

  @HiveField(11)
  final DateTime? completedAt;

  @HiveField(12)
  final bool isCancelled; // true = cancelado

  @HiveField(13)
  final DateTime? cancelledAt;

  const AppointmentSavedModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.consultationType,
    required this.date,
    required this.time,
    required this.priority,
    required this.paymentMethod,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
    this.isCancelled = false,
    this.cancelledAt,
  });

  /// Cria uma cópia do modelo com campos atualizados
  AppointmentSavedModel copyWith({
    String? id,
    String? doctorName,
    String? specialty,
    String? clinicName,
    String? consultationType,
    String? date,
    String? time,
    String? priority,
    String? paymentMethod,
    DateTime? createdAt,
    bool? isCompleted,
    DateTime? completedAt,
    bool? isCancelled,
    DateTime? cancelledAt,
  }) {
    return AppointmentSavedModel(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      clinicName: clinicName ?? this.clinicName,
      consultationType: consultationType ?? this.consultationType,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isCancelled: isCancelled ?? this.isCancelled,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  @override
  String toString() {
    return 'AppointmentSavedModel(id: $id, doctor: $doctorName, date: $date $time, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointmentSavedModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

