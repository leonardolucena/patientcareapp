import '../../data/models/reminder_model.dart';

/// Interface abstrata para o repositório de lembretes
abstract class ReminderRepository {
  /// Adiciona um novo lembrete
  Future<void> addReminder(ReminderModel reminder);

  /// Obtém todos os lembretes
  Future<List<ReminderModel>> getAllReminders();

  /// Obtém um lembrete pelo ID
  Future<ReminderModel?> getReminderById(String id);

  /// Atualiza um lembrete existente
  Future<void> updateReminder(ReminderModel reminder);

  /// Remove um lembrete
  Future<void> deleteReminder(String id);

  /// Obtém lembretes futuros (não vencidos)
  Future<List<ReminderModel>> getUpcomingReminders();

  /// Obtém lembretes vencidos
  Future<List<ReminderModel>> getOverdueReminders();

  /// Obtém lembretes de hoje
  Future<List<ReminderModel>> getTodayReminders();

  /// Obtém lembretes por período
  Future<List<ReminderModel>> getRemindersByDateRange(
    DateTime start,
    DateTime end,
  );
}

