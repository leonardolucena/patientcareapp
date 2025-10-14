import 'package:hive/hive.dart';

part 'medical_record_model.g.dart';

/// Tipos de registros médicos
enum MedicalRecordType {
  consultation,    // Consulta
  exam,           // Exame
  medication,     // Medicação
  vaccine,        // Vacina
  surgery,        // Cirurgia
  allergy,        // Alergia
  condition,      // Condição/Doença crônica
  other,          // Outro
}

/// Model para histórico médico salvo localmente no Hive
@HiveType(typeId: 2)
class MedicalRecordModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category; // Tipo do registro (consultation, exam, etc.)

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? doctorName;

  @HiveField(6)
  final String? specialty;

  @HiveField(7)
  final String? location; // Hospital/Clínica

  @HiveField(8)
  final List<String>? attachments; // Paths de arquivos anexados

  @HiveField(9)
  final String? notes; // Notas adicionais

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  const MedicalRecordModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.doctorName,
    this.specialty,
    this.location,
    this.attachments,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  /// Cria uma cópia do modelo com campos atualizados
  MedicalRecordModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    String? doctorName,
    String? specialty,
    String? location,
    List<String>? attachments,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRecordModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      location: location ?? this.location,
      attachments: attachments ?? this.attachments,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'MedicalRecordModel(id: $id, title: $title, category: $category, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicalRecordModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

