import 'dart:math';

/// Utilitário para geração de IDs únicos
/// Segue o Single Responsibility Principle (SRP)
class IdGenerator {
  static final Random _random = Random();

  /// Gera um ID único simples
  /// Em produção, usaria UUID ou ID do backend
  static String generate(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(9999);
    return '${prefix}_${timestamp}_$random';
  }

  /// Gera ID para agendamento
  static String generateAppointmentId() => generate('appt');

  /// Gera ID para revisão
  static String generateReviewId() => generate('rev');
}

