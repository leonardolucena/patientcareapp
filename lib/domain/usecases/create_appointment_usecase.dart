import 'package:patientcareapp/data/models/appointment_model.dart';
import 'package:patientcareapp/domain/repositories/appointment_repository.dart';

/// Use Case para criar um agendamento
/// Segue o Single Responsibility Principle (SRP)
class CreateAppointmentUseCase {
  final AppointmentRepository _repository;

  CreateAppointmentUseCase(this._repository);

  Future<AppointmentModel> call(AppointmentModel appointment) async {
    // Aqui poderia ter validações de negócio
    // Ex: verificar se o horário está disponível, etc.
    return await _repository.createAppointment(appointment);
  }
}

