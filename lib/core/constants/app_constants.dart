/// Constantes da aplicação
/// Segue o DRY (Don't Repeat Yourself) principle
class AppConstants {
  // IDs padrão
  static const String defaultPatientId = 'patient_001';

  // Status de agendamento
  static const String appointmentStatusScheduled = 'scheduled';
  static const String appointmentStatusCompleted = 'completed';
  static const String appointmentStatusCancelled = 'cancelled';

  // Tipos de consulta
  static const String consultationTypeOnline = 'online';
  static const String consultationTypeInPerson = 'inPerson';

  // Prioridades
  static const String priorityNormal = 'normal';
  static const String priorityUrgent = 'urgent';

  // Métodos de pagamento
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodCreditCard = 'creditCard';

  // Animações
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}

