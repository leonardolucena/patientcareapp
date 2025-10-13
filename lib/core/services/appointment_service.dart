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

  /// Obtém agendamentos abertos (não concluídos)
  List<AppointmentSavedModel> getOpenAppointments() {
    return _appointmentsBox.values
        .where((appointment) => !appointment.isCompleted)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Obtém agendamentos fechados (concluídos)
  List<AppointmentSavedModel> getClosedAppointments() {
    return _appointmentsBox.values
        .where((appointment) => appointment.isCompleted)
        .toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
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

