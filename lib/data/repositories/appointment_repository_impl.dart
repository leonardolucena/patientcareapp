import 'package:patientcareapp/data/models/appointment_model.dart';
import 'package:patientcareapp/domain/repositories/appointment_repository.dart';

/// Implementação do repositório de agendamentos
/// Segue o Dependency Inversion Principle (DIP)
class AppointmentRepositoryImpl implements AppointmentRepository {
  // Lista em memória para armazenar agendamentos
  // Em produção, seria um banco de dados ou API
  final List<AppointmentModel> _appointments = [];

  @override
  Future<AppointmentModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _appointments.add(appointment);
    return appointment;
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByPatientId(
    String patientId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _appointments
        .where((appt) => appt.patientId == patientId)
        .toList();
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDoctorId(
    String doctorId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _appointments
        .where((appt) => appt.doctorId == doctorId)
        .toList();
  }

  @override
  Future<AppointmentModel?> getAppointmentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _appointments.firstWhere((appt) => appt.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cancelAppointment(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _appointments.indexWhere((appt) => appt.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: 'cancelled',
      );
    }
  }

  @override
  Future<AppointmentModel> updateAppointment(
    AppointmentModel appointment,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _appointments.indexWhere((appt) => appt.id == appointment.id);
    if (index != -1) {
      _appointments[index] = appointment;
    }
    return appointment;
  }
}

