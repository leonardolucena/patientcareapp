import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Serviço para tradução de especialidades
/// Segue o Single Responsibility Principle (SRP)
class SpecialtyTranslationService {
  /// Mapeia especialidade em português para a chave i18n
  static String getSpecialtyKey(String translatedName, AppLocalizations l10n) {
    if (translatedName == l10n.all) return 'Todos';
    if (translatedName == l10n.cardiology) return 'Cardiologia';
    if (translatedName == l10n.dermatology) return 'Dermatologia';
    if (translatedName == l10n.orthopedics) return 'Ortopedia';
    if (translatedName == l10n.pediatrics) return 'Pediatria';
    if (translatedName == l10n.neurology) return 'Neurologia';
    if (translatedName == l10n.ophthalmology) return 'Oftalmologia';
    if (translatedName == l10n.gynecology) return 'Ginecologia';
    if (translatedName == l10n.psychiatry) return 'Psiquiatria';
    return translatedName;
  }

  /// Traduz especialidade do português para o idioma atual
  static String translateSpecialty(String portugueseName, AppLocalizations l10n) {
    switch (portugueseName) {
      case 'Cardiologia':
        return l10n.cardiology;
      case 'Dermatologia':
        return l10n.dermatology;
      case 'Ortopedia':
        return l10n.orthopedics;
      case 'Pediatria':
        return l10n.pediatrics;
      case 'Neurologia':
        return l10n.neurology;
      case 'Oftalmologia':
        return l10n.ophthalmology;
      case 'Ginecologia':
        return l10n.gynecology;
      case 'Psiquiatria':
        return l10n.psychiatry;
      default:
        return portugueseName;
    }
  }
}

