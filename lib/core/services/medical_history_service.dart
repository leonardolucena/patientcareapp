import 'package:hive/hive.dart';
import '../../data/models/medical_record_model.dart';

/// Serviço para gerenciar histórico médico localmente
class MedicalHistoryService {
  static const String _medicalHistoryBoxName = 'medical_history';

  /// Box do Hive para armazenar registros médicos
  late Box<MedicalRecordModel> _medicalHistoryBox;

  /// Inicializa o serviço e abre o box do Hive
  Future<void> initialize() async {
    _medicalHistoryBox = await Hive.openBox<MedicalRecordModel>(_medicalHistoryBoxName);
  }

  /// Gera um ID único para o registro
  String _generateRecordId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'record_$timestamp';
  }

  /// Adiciona um novo registro médico
  Future<MedicalRecordModel> addRecord({
    required String title,
    required String description,
    required String category,
    required DateTime date,
    String? doctorName,
    String? specialty,
    String? location,
    List<String>? attachments,
    String? notes,
  }) async {
    final record = MedicalRecordModel(
      id: _generateRecordId(),
      title: title,
      description: description,
      category: category,
      date: date,
      doctorName: doctorName,
      specialty: specialty,
      location: location,
      attachments: attachments,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await _medicalHistoryBox.put(record.id, record);
    return record;
  }

  /// Obtém todos os registros médicos
  List<MedicalRecordModel> getAllRecords() {
    return _medicalHistoryBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Mais recentes primeiro
  }

  /// Obtém registros por categoria
  List<MedicalRecordModel> getRecordsByCategory(String category) {
    return _medicalHistoryBox.values
        .where((record) => record.category == category)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Obtém registros por período
  List<MedicalRecordModel> getRecordsByPeriod(DateTime start, DateTime end) {
    return _medicalHistoryBox.values
        .where((record) =>
            record.date.isAfter(start.subtract(const Duration(days: 1))) &&
            record.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Busca registros por texto
  List<MedicalRecordModel> searchRecords(String query) {
    final lowerQuery = query.toLowerCase();
    return _medicalHistoryBox.values
        .where((record) =>
            record.title.toLowerCase().contains(lowerQuery) ||
            record.description.toLowerCase().contains(lowerQuery) ||
            (record.doctorName?.toLowerCase().contains(lowerQuery) ?? false) ||
            (record.location?.toLowerCase().contains(lowerQuery) ?? false))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Atualiza um registro médico
  Future<void> updateRecord(MedicalRecordModel record) async {
    final updatedRecord = record.copyWith(updatedAt: DateTime.now());
    await _medicalHistoryBox.put(updatedRecord.id, updatedRecord);
  }

  /// Deleta um registro médico
  Future<void> deleteRecord(String recordId) async {
    await _medicalHistoryBox.delete(recordId);
  }

  /// Obtém um registro específico
  MedicalRecordModel? getRecord(String recordId) {
    return _medicalHistoryBox.get(recordId);
  }

  /// Obtém estatísticas dos registros
  Map<String, int> getStatistics() {
    final all = getAllRecords();
    final categories = <String, int>{};

    for (var record in all) {
      categories[record.category] = (categories[record.category] ?? 0) + 1;
    }

    return {
      'total': all.length,
      ...categories,
    };
  }

  /// Limpa todos os registros (útil para testes)
  Future<void> clearAll() async {
    await _medicalHistoryBox.clear();
  }

  /// Fecha o box do Hive
  Future<void> dispose() async {
    await _medicalHistoryBox.close();
  }
}

