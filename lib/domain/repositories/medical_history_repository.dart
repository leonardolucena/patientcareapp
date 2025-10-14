import '../../data/models/medical_record_model.dart';

abstract class MedicalHistoryRepository {
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
  });

  List<MedicalRecordModel> getAllRecords();
  List<MedicalRecordModel> getRecordsByCategory(String category);
  List<MedicalRecordModel> getRecordsByPeriod(DateTime start, DateTime end);
  List<MedicalRecordModel> searchRecords(String query);
  Future<void> updateRecord(MedicalRecordModel record);
  Future<void> deleteRecord(String recordId);
  MedicalRecordModel? getRecord(String recordId);
  Map<String, int> getStatistics();
}

