import 'package:flutter/foundation.dart';
import '../../data/models/medical_record_model.dart';
import '../../domain/repositories/medical_history_repository.dart';

class MedicalHistoryProvider with ChangeNotifier {
  final MedicalHistoryRepository _repository;
  List<MedicalRecordModel> _records = [];
  String? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;

  MedicalHistoryProvider(this._repository) {
    loadRecords();
  }

  List<MedicalRecordModel> get records => List.unmodifiable(_records);
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  /// Carrega todos os registros
  void loadRecords() {
    _isLoading = true;
    notifyListeners();

    try {
      if (_searchQuery.isNotEmpty) {
        _records = _repository.searchRecords(_searchQuery);
      } else if (_selectedCategory != null) {
        _records = _repository.getRecordsByCategory(_selectedCategory!);
      } else {
        _records = _repository.getAllRecords();
      }
    } catch (e) {
      debugPrint('Erro ao carregar registros: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adiciona um novo registro
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
    try {
      final record = await _repository.addRecord(
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
      loadRecords();
      return record;
    } catch (e) {
      debugPrint('Erro ao adicionar registro: $e');
      rethrow;
    }
  }

  /// Atualiza um registro
  Future<void> updateRecord(MedicalRecordModel record) async {
    try {
      await _repository.updateRecord(record);
      loadRecords();
    } catch (e) {
      debugPrint('Erro ao atualizar registro: $e');
      rethrow;
    }
  }

  /// Deleta um registro
  Future<void> deleteRecord(String recordId) async {
    try {
      await _repository.deleteRecord(recordId);
      loadRecords();
    } catch (e) {
      debugPrint('Erro ao deletar registro: $e');
      rethrow;
    }
  }

  /// Filtra por categoria
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _searchQuery = '';
    loadRecords();
  }

  /// Busca registros
  void search(String query) {
    _searchQuery = query;
    _selectedCategory = null;
    loadRecords();
  }

  /// Limpa filtros
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    loadRecords();
  }

  /// Obtém estatísticas
  Map<String, int> getStatistics() {
    try {
      return _repository.getStatistics();
    } catch (e) {
      debugPrint('Erro ao obter estatísticas: $e');
      return {};
    }
  }

  /// Obtém registros agrupados por mês
  Map<String, List<MedicalRecordModel>> getRecordsGroupedByMonth() {
    final grouped = <String, List<MedicalRecordModel>>{};
    
    for (var record in _records) {
      final monthKey = '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}';
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(record);
    }
    
    return grouped;
  }
}

