import 'package:flutter/material.dart';
import '../../data/models/reminder_model.dart';
import '../../domain/repositories/reminder_repository.dart';

/// Provider para gerenciar o estado dos lembretes
class ReminderProvider with ChangeNotifier {
  final ReminderRepository _repository;

  ReminderProvider(this._repository) {
    _loadReminders();
  }

  List<ReminderModel> _reminders = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _filterType = 'all'; // all, upcoming, overdue, today

  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get filterType => _filterType;

  /// Carrega todos os lembretes
  Future<void> _loadReminders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reminders = await _repository.getAllReminders();
      _sortReminders();
    } catch (e) {
      _errorMessage = 'Erro ao carregar lembretes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ordena os lembretes por data do lembrete
  void _sortReminders() {
    _reminders.sort((a, b) => a.reminderDate.compareTo(b.reminderDate));
  }

  /// Atualiza a lista de lembretes
  Future<void> refreshReminders() async {
    await _loadReminders();
  }

  /// Adiciona um novo lembrete
  Future<void> addReminder(ReminderModel reminder) async {
    try {
      await _repository.addReminder(reminder);
      await refreshReminders();
    } catch (e) {
      _errorMessage = 'Erro ao adicionar lembrete: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Atualiza um lembrete existente
  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await _repository.updateReminder(reminder);
      await refreshReminders();
    } catch (e) {
      _errorMessage = 'Erro ao atualizar lembrete: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Remove um lembrete
  Future<void> deleteReminder(String id) async {
    try {
      await _repository.deleteReminder(id);
      _reminders.removeWhere((reminder) => reminder.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao remover lembrete: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Altera o filtro de visualização
  void setFilter(String filter) {
    _filterType = filter;
    notifyListeners();
  }

  /// Obtém os lembretes filtrados
  List<ReminderModel> get filteredReminders {
    switch (_filterType) {
      case 'upcoming':
        return _reminders.where((r) => !r.isOverdue).toList();
      case 'overdue':
        return _reminders.where((r) => r.isOverdue).toList();
      case 'today':
        return _reminders.where((r) => r.isToday).toList();
      case 'all':
      default:
        return _reminders;
    }
  }

  /// Obtém a contagem de lembretes vencidos
  int get overdueCount => _reminders.where((r) => r.isOverdue).length;

  /// Obtém a contagem de lembretes de hoje
  int get todayCount => _reminders.where((r) => r.isToday).length;

  /// Obtém a contagem de lembretes futuros
  int get upcomingCount => _reminders.where((r) => !r.isOverdue && !r.isToday).length;
}

