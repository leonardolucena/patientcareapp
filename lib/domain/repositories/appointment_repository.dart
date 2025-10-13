import 'package:patientcareapp/data/models/appointment_model.dart';

/// Interface do repositório de agendamentos
/// Segue o Dependency Inversion Principle (DIP) - depende de abstração
abstract class AppointmentRepository {
  /// Cria um novo agendamento
  Future<AppointmentModel> createAppointment(AppointmentModel appointment);

  /// Retorna todos os agendamentos de um paciente
  Future<List<AppointmentModel>> getAppointmentsByPatientId(String patientId);

  /// Retorna todos os agendamentos de um médico
  Future<List<AppointmentModel>> getAppointmentsByDoctorId(String doctorId);

  /// Retorna um agendamento pelo ID
  Future<AppointmentModel?> getAppointmentById(String id);

  /// Cancela um agendamento
  Future<void> cancelAppointment(String id);

  /// Atualiza um agendamento
  Future<AppointmentModel> updateAppointment(AppointmentModel appointment);
}

