import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

/// Model para lembretes de consultas salvos localmente no Hive
@HiveType(typeId: 3)
class ReminderModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime appointmentDate;

  @HiveField(4)
  final DateTime reminderDate;

  @HiveField(5)
  final String? doctorName;

  @HiveField(6)
  final String? location;

  @HiveField(7)
  final bool isCompleted;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime? completedAt;

  @HiveField(10)
  final String? notes;

  const ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.appointmentDate,
    required this.reminderDate,
    this.doctorName,
    this.location,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.notes,
  });

  /// Verifica se o lembrete está vencido
  bool get isOverdue {
    return !isCompleted && DateTime.now().isAfter(appointmentDate);
  }

  /// Verifica se o lembrete é para hoje
  bool get isToday {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
  }

  /// Verifica se o lembrete é para amanhã
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return appointmentDate.year == tomorrow.year &&
        appointmentDate.month == tomorrow.month &&
        appointmentDate.day == tomorrow.day;
  }

  /// Dias até a consulta
  int get daysUntilAppointment {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now);
    return difference.inDays;
  }

  /// Cria uma cópia do modelo com campos atualizados
  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? appointmentDate,
    DateTime? reminderDate,
    String? doctorName,
    String? location,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    String? notes,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      reminderDate: reminderDate ?? this.reminderDate,
      doctorName: doctorName ?? this.doctorName,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'ReminderModel(id: $id, title: $title, appointmentDate: $appointmentDate, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReminderModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

