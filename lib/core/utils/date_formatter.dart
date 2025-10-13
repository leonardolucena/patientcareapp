import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Utilitário para formatação de datas
/// Segue o Single Responsibility Principle (SRP)
class DateFormatter {
  /// Retorna o nome do dia da semana traduzido
  static String getWeekdayName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return '';
    }
  }

  /// Retorna o nome abreviado do dia da semana
  static String getWeekdayShortName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case 1:
        return l10n.mondayShort;
      case 2:
        return l10n.tuesdayShort;
      case 3:
        return l10n.wednesdayShort;
      case 4:
        return l10n.thursdayShort;
      case 5:
        return l10n.fridayShort;
      case 6:
        return l10n.saturdayShort;
      case 7:
        return l10n.sundayShort;
      default:
        return '';
    }
  }

  /// Formata data no padrão dd/MM/yyyy
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Formata hora no padrão HH:mm
  static String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  /// Formata data e hora juntas
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }
}

