import '../../core/services/medical_history_service.dart';
import '../../domain/repositories/medical_history_repository.dart';
import '../models/medical_record_model.dart';

class MedicalHistoryRepositoryImpl implements MedicalHistoryRepository {
  final MedicalHistoryService _service;

  MedicalHistoryRepositoryImpl(this._service);

  @override
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
    return await _service.addRecord(
      title: title,
      description: description,
      category: category,
      date: date,
      doctorName: doctorName,
      specialty: specialty,
      location: location,
      attachments: attachments,
      notes: notes,
    );
  }

  @override
  List<MedicalRecordModel> getAllRecords() {
    return _service.getAllRecords();
  }

  @override
  List<MedicalRecordModel> getRecordsByCategory(String category) {
    return _service.getRecordsByCategory(category);
  }

  @override
  List<MedicalRecordModel> getRecordsByPeriod(DateTime start, DateTime end) {
    return _service.getRecordsByPeriod(start, end);
  }

  @override
  List<MedicalRecordModel> searchRecords(String query) {
    return _service.searchRecords(query);
  }

  @override
  Future<void> updateRecord(MedicalRecordModel record) async {
    await _service.updateRecord(record);
  }

  @override
  Future<void> deleteRecord(String recordId) async {
    await _service.deleteRecord(recordId);
  }

  @override
  MedicalRecordModel? getRecord(String recordId) {
    return _service.getRecord(recordId);
  }

  @override
  Map<String, int> getStatistics() {
    return _service.getStatistics();
  }
}

