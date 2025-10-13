import 'package:flutter/material.dart';

/// Paleta de cores do PatientCare App
class AppColors {
  // Cores Primárias
  static const Color primaryDark = Color(0xFF05151A);    // Azul escuro profundo
  static const Color primaryTeal = Color(0xFF3F7884);    // Azul-esverdeado suave (COR PRINCIPAL)
  static const Color primaryTealDark = Color(0xFF0C7076); // Verde-azulado escuro
  static const Color primaryBlue = Color(0xFF0706FC);    // Azul royal
  static const Color primaryCyan = Color(0xFF6DA6C0);    // Azul claro
  static const Color primaryNavy = Color(0xFF294D61);    // Azul marinho

  // ========== LIGHT MODE ==========
  
  // Backgrounds Light
  static const Color lightBackground = Color(0xFFF5F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  
  // Primary Light (Azul-esverdeado suave como cor principal)
  static const Color lightPrimary = Color(0xFF3F7884);
  static const Color lightPrimaryLight = Color(0xFF6FA1AB);
  static const Color lightPrimaryDark = Color(0xFF2A5560);
  
  // Secondary Light (Azul claro)
  static const Color lightSecondary = Color(0xFF6DA6C0);
  static const Color lightSecondaryLight = Color(0xFF9AC8DB);
  static const Color lightSecondaryDark = Color(0xFF4A7A8E);
  
  // Accent Light (Azul royal)
  static const Color lightAccent = Color(0xFF0706FC);
  static const Color lightAccentLight = Color(0xFF5B5AFF);
  static const Color lightAccentDark = Color(0xFF0504C9);
  
  // Tertiary Light (Verde-azulado)
  static const Color lightTertiary = Color(0xFF0C7076);
  static const Color lightTertiaryLight = Color(0xFF3FA0A6);
  static const Color lightTertiaryDark = Color(0xFF094F54);
  
  // Text Light
  static const Color lightTextPrimary = Color(0xFF05151A);
  static const Color lightTextSecondary = Color(0xFF294D61);
  static const Color lightTextTertiary = Color(0xFF6DA6C0);
  static const Color lightTextDisabled = Color(0xFFB0C4CE);
  
  // Others Light
  static const Color lightDivider = Color(0xFFE0EBF0);
  static const Color lightBorder = Color(0xFFD0DDE5);
  static const Color lightError = Color(0xFFE53935);
  static const Color lightSuccess = Color(0xFF3F7884);
  static const Color lightWarning = Color(0xFFFFA726);
  static const Color lightInfo = Color(0xFF0706FC);

  // ========== DARK MODE ==========
  
  // Backgrounds Dark
  static const Color darkBackground = Color(0xFF05151A);
  static const Color darkSurface = Color(0xFF0A1F26);
  static const Color darkCardBackground = Color(0xFF0F2A33);
  
  // Primary Dark (Azul-esverdeado mais claro para dark mode)
  static const Color darkPrimary = Color(0xFF5A99A8);
  static const Color darkPrimaryLight = Color(0xFF8ABBC7);
  static const Color darkPrimaryDark = Color(0xFF3F7884);
  
  // Secondary Dark (Azul claro mais suave)
  static const Color darkSecondary = Color(0xFF8BBFD6);
  static const Color darkSecondaryLight = Color(0xFFB5D9E8);
  static const Color darkSecondaryDark = Color(0xFF5A8FA8);
  
  // Accent Dark (Azul royal mais suave)
  static const Color darkAccent = Color(0xFF5B5AFF);
  static const Color darkAccentLight = Color(0xFF9493FF);
  static const Color darkAccentDark = Color(0xFF0504C9);
  
  // Tertiary Dark (Verde-azulado mais suave)
  static const Color darkTertiary = Color(0xFF139BA3);
  static const Color darkTertiaryLight = Color(0xFF4CBBC2);
  static const Color darkTertiaryDark = Color(0xFF0D6D72);
  
  // Text Dark
  static const Color darkTextPrimary = Color(0xFFE8F4F8);
  static const Color darkTextSecondary = Color(0xFFB5D2DF);
  static const Color darkTextTertiary = Color(0xFF8BBFD6);
  static const Color darkTextDisabled = Color(0xFF4A6977);
  
  // Others Dark
  static const Color darkDivider = Color(0xFF1A3742);
  static const Color darkBorder = Color(0xFF254855);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkSuccess = Color(0xFF5A99A8);
  static const Color darkWarning = Color(0xFFFFB74D);
  static const Color darkInfo = Color(0xFF5B5AFF);
  
  // ========== GRADIENTES ==========
  
  static const List<Color> lightPrimaryGradient = [
    Color(0xFF3F7884),
    Color(0xFF6DA6C0),
  ];
  
  static const List<Color> darkPrimaryGradient = [
    Color(0xFF5A99A8),
    Color(0xFF8BBFD6),
  ];
  
  static const List<Color> lightAccentGradient = [
    Color(0xFF0706FC),
    Color(0xFF6DA6C0),
  ];
  
  static const List<Color> darkAccentGradient = [
    Color(0xFF5B5AFF),
    Color(0xFF8BBFD6),
  ];
}

