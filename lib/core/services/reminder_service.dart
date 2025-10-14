import 'package:hive/hive.dart';
import '../../data/models/reminder_model.dart';

/// Serviço para gerenciar lembretes de consultas localmente
class ReminderService {
  static const String _remindersBoxName = 'reminders';

  /// Box do Hive para armazenar lembretes
  late Box<ReminderModel> _remindersBox;

  /// Inicializa o serviço e abre o box do Hive
  Future<void> initialize() async {
    _remindersBox = await Hive.openBox<ReminderModel>(_remindersBoxName);
  }

  /// Gera um ID único para o lembrete
  String _generateReminderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'reminder_$timestamp';
  }

  /// Adiciona um novo lembrete
  Future<ReminderModel> addReminder({
    required String title,
    required String description,
    required DateTime appointmentDate,
    required DateTime reminderDate,
    String? doctorName,
    String? location,
    String? notes,
  }) async {
    final reminder = ReminderModel(
      id: _generateReminderId(),
      title: title,
      description: description,
      appointmentDate: appointmentDate,
      reminderDate: reminderDate,
      doctorName: doctorName,
      location: location,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await _remindersBox.put(reminder.id, reminder);
    return reminder;
  }

  /// Obtém todos os lembretes
  List<ReminderModel> getAllReminders() {
    return _remindersBox.values.toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  /// Obtém lembretes ativos (não concluídos)
  List<ReminderModel> getActiveReminders() {
    return _remindersBox.values
        .where((reminder) => !reminder.isCompleted)
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  /// Obtém lembretes concluídos
  List<ReminderModel> getCompletedReminders() {
    return _remindersBox.values
        .where((reminder) => reminder.isCompleted)
        .toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  /// Obtém lembretes vencidos
  List<ReminderModel> getOverdueReminders() {
    return _remindersBox.values
        .where((reminder) => reminder.isOverdue)
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  /// Obtém lembretes de hoje
  List<ReminderModel> getTodayReminders() {
    return _remindersBox.values
        .where((reminder) => !reminder.isCompleted && reminder.isToday)
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  /// Obtém lembretes próximos (próximos 7 dias)
  List<ReminderModel> getUpcomingReminders() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    
    return _remindersBox.values
        .where((reminder) =>
            !reminder.isCompleted &&
            reminder.appointmentDate.isAfter(now) &&
            reminder.appointmentDate.isBefore(nextWeek))
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  /// Marca um lembrete como concluído
  Future<void> completeReminder(String reminderId) async {
    final reminder = _remindersBox.get(reminderId);
    if (reminder != null) {
      final completedReminder = reminder.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      await _remindersBox.put(reminderId, completedReminder);
    }
  }

  /// Desmarca um lembrete como concluído
  Future<void> uncompleteReminder(String reminderId) async {
    final reminder = _remindersBox.get(reminderId);
    if (reminder != null) {
      final uncompletedReminder = reminder.copyWith(
        isCompleted: false,
        completedAt: null,
      );
      await _remindersBox.put(reminderId, uncompletedReminder);
    }
  }

  /// Atualiza um lembrete
  Future<void> updateReminder(ReminderModel reminder) async {
    await _remindersBox.put(reminder.id, reminder);
  }

  /// Deleta um lembrete
  Future<void> deleteReminder(String reminderId) async {
    await _remindersBox.delete(reminderId);
  }

  /// Obtém um lembrete específico
  ReminderModel? getReminder(String reminderId) {
    return _remindersBox.get(reminderId);
  }

  /// Obtém estatísticas dos lembretes
  Map<String, int> getStatistics() {
    final all = getAllReminders();
    final active = getActiveReminders();
    final completed = getCompletedReminders();
    final overdue = getOverdueReminders();
    final today = getTodayReminders();

    return {
      'total': all.length,
      'active': active.length,
      'completed': completed.length,
      'overdue': overdue.length,
      'today': today.length,
    };
  }

  /// Limpa todos os lembretes (útil para testes)
  Future<void> clearAll() async {
    await _remindersBox.clear();
  }

  /// Fecha o box do Hive
  Future<void> dispose() async {
    await _remindersBox.close();
  }
}

