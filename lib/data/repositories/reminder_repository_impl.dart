import '../../core/services/reminder_service.dart';
import '../../data/models/reminder_model.dart';
import '../../domain/repositories/reminder_repository.dart';

/// Implementação concreta do repositório de lembretes
class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderService _reminderService;

  ReminderRepositoryImpl(this._reminderService);

  @override
  Future<void> addReminder(ReminderModel reminder) async {
    await _reminderService.updateReminder(reminder);
  }

  @override
  Future<List<ReminderModel>> getAllReminders() async {
    return _reminderService.getAllReminders();
  }

  @override
  Future<ReminderModel?> getReminderById(String id) async {
    return _reminderService.getReminder(id);
  }

  @override
  Future<void> updateReminder(ReminderModel reminder) async {
    await _reminderService.updateReminder(reminder);
  }

  @override
  Future<void> deleteReminder(String id) async {
    await _reminderService.deleteReminder(id);
  }

  @override
  Future<List<ReminderModel>> getUpcomingReminders() async {
    return _reminderService.getUpcomingReminders();
  }

  @override
  Future<List<ReminderModel>> getOverdueReminders() async {
    return _reminderService.getOverdueReminders();
  }

  @override
  Future<List<ReminderModel>> getTodayReminders() async {
    return _reminderService.getTodayReminders();
  }

  @override
  Future<List<ReminderModel>> getRemindersByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final allReminders = await getAllReminders();
    return allReminders
        .where((reminder) =>
            reminder.appointmentDate.isAfter(start) &&
            reminder.appointmentDate.isBefore(end))
        .toList();
  }
}

