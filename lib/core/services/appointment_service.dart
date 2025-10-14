import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:patientcareapp/data/models/appointment_saved_model.dart';

/// Serviço para gerenciar agendamentos salvos localmente
/// 
/// Responsável por:
/// - Salvar novos agendamentos
/// - Buscar agendamentos (abertos/fechados)
/// - Marcar agendamentos como concluídos
/// - Calcular estatísticas
class AppointmentService {
  static const String _appointmentsBoxName = 'appointments';

  /// Box do Hive para armazenar agendamentos
  late Box<AppointmentSavedModel> _appointmentsBox;

  /// Inicializa o serviço e abre o box do Hive
  Future<void> initialize() async {
    _appointmentsBox = await Hive.openBox<AppointmentSavedModel>(_appointmentsBoxName);
  }

  /// Gera um ID único para o agendamento
  String _generateAppointmentId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'appt_$timestamp';
  }

  /// Salva um novo agendamento
  Future<AppointmentSavedModel> saveAppointment({
    required String doctorName,
    required String specialty,
    required String clinicName,
    required String consultationType,
    required String date,
    required String time,
    required String priority,
    required String paymentMethod,
  }) async {
    final appointment = AppointmentSavedModel(
      id: _generateAppointmentId(),
      doctorName: doctorName,
      specialty: specialty,
      clinicName: clinicName,
      consultationType: consultationType,
      date: date,
      time: time,
      priority: priority,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );

    await _appointmentsBox.put(appointment.id, appointment);
    return appointment;
  }

  /// Obtém todos os agendamentos
  List<AppointmentSavedModel> getAllAppointments() {
    return _appointmentsBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Mais recentes primeiro
  }

  /// Obtém agendamentos abertos (não concluídos e não cancelados)
  List<AppointmentSavedModel> getOpenAppointments() {
    return _appointmentsBox.values
        .where((appointment) => !appointment.isCompleted && !appointment.isCancelled)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Obtém agendamentos fechados (concluídos ou cancelados)
  List<AppointmentSavedModel> getClosedAppointments() {
    return _appointmentsBox.values
        .where((appointment) => appointment.isCompleted || appointment.isCancelled)
        .toList()
      ..sort((a, b) {
        final aDate = a.completedAt ?? a.cancelledAt ?? a.createdAt;
        final bDate = b.completedAt ?? b.cancelledAt ?? b.createdAt;
        return bDate.compareTo(aDate);
      });
  }

  /// Marca um agendamento como concluído
  Future<void> completeAppointment(String appointmentId) async {
    final appointment = _appointmentsBox.get(appointmentId);
    if (appointment != null) {
      final completedAppointment = appointment.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      await _appointmentsBox.put(appointmentId, completedAppointment);
    }
  }

  /// Cancela um agendamento
  Future<void> cancelAppointment(String appointmentId) async {
    final appointment = _appointmentsBox.get(appointmentId);
    if (appointment != null && !appointment.isCancelled) {
      final cancelledAppointment = appointment.copyWith(
        isCancelled: true,
        cancelledAt: DateTime.now(),
      );
      await _appointmentsBox.put(appointmentId, cancelledAppointment);
    }
  }

  /// Verifica e atualiza automaticamente consultas que passaram da data
  Future<void> updateExpiredAppointments() async {
    final now = DateTime.now();
    final openAppointments = getOpenAppointments();

    for (final appointment in openAppointments) {
      // Parse da data e hora do agendamento
      try {
        final dateParts = appointment.date.split('/'); // Ex: 15/11/2024
        final timeParts = appointment.time.split(':'); // Ex: 10:00

        if (dateParts.length == 3 && timeParts.length == 2) {
          final appointmentDateTime = DateTime(
            int.parse(dateParts[2]), // ano
            int.parse(dateParts[1]), // mês
            int.parse(dateParts[0]), // dia
            int.parse(timeParts[0]), // hora
            int.parse(timeParts[1]), // minuto
          );

          // Debug: Log informações
          log('DEBUG - Appointment: ${appointment.doctorName}');
          log('  Data string: ${appointment.date} ${appointment.time}');
          log('  DateTime parsed: $appointmentDateTime');
          log('  Now: $now');
          log('  Is before now? ${appointmentDateTime.isBefore(now)}');
          log('  Difference: ${appointmentDateTime.difference(now)}');

          // Só marca como concluído se a data E hora já passaram
          // Adicionamos 1 hora de margem para garantir que a consulta realmente aconteceu
          final hourAfterAppointment = appointmentDateTime.add(const Duration(hours: 1));
          if (now.isAfter(hourAfterAppointment)) {
            log('  -> Marcando como concluída');
            final completedAppointment = appointment.copyWith(
              isCompleted: true,
              completedAt: appointmentDateTime,
            );
            await _appointmentsBox.put(appointment.id, completedAppointment);
          } else {
            log('  -> Ainda não passou (mantendo aberta)');
          }
        }
      } catch (e) {
        log('ERROR parsing appointment: $e');
        // Se houver erro no parse, ignora este agendamento
        continue;
      }
    }
  }

  /// Reabre consultas que foram marcadas como concluídas incorretamente (data futura)
  Future<void> reopenFutureCompletedAppointments() async {
    final now = DateTime.now();
    final closedAppointments = getClosedAppointments();

    for (final appointment in closedAppointments) {
      // Só verifica consultas marcadas como concluídas (não canceladas)
      if (!appointment.isCompleted || appointment.isCancelled) continue;

      try {
        final dateParts = appointment.date.split('/');
        final timeParts = appointment.time.split(':');

        if (dateParts.length == 3 && timeParts.length == 2) {
          final appointmentDateTime = DateTime(
            int.parse(dateParts[2]), // ano
            int.parse(dateParts[1]), // mês
            int.parse(dateParts[0]), // dia
            int.parse(timeParts[0]), // hora
            int.parse(timeParts[1]), // minuto
          );

          // Se a consulta é NO FUTURO mas está marcada como concluída
          if (appointmentDateTime.isAfter(now)) {
            log('REOPENING future appointment: ${appointment.doctorName} - ${appointment.date} ${appointment.time}');
            final reopenedAppointment = appointment.copyWith(
              isCompleted: false,
              completedAt: null,
            );
            await _appointmentsBox.put(appointment.id, reopenedAppointment);
          }
        }
      } catch (e) {
        log('ERROR reopening appointment: $e');
        continue;
      }
    }
  }

  /// Deleta um agendamento
  Future<void> deleteAppointment(String appointmentId) async {
    await _appointmentsBox.delete(appointmentId);
  }

  /// Obtém estatísticas dos agendamentos
  Map<String, int> getStatistics() {
    final all = getAllAppointments();
    final completed = getClosedAppointments();
    final open = getOpenAppointments();
    
    // Contar médicos únicos
    final uniqueDoctors = all.map((a) => a.doctorName).toSet();

    return {
      'total': all.length,
      'completed': completed.length,
      'open': open.length,
      'doctors': uniqueDoctors.length,
    };
  }

  /// Limpa todos os agendamentos (útil para testes)
  Future<void> clearAll() async {
    await _appointmentsBox.clear();
  }

  /// Fecha o box do Hive
  Future<void> dispose() async {
    await _appointmentsBox.close();
  }
}

