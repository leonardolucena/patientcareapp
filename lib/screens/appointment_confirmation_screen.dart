import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patientcareapp/core/services/appointment_service.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  final String doctorName;
  final String clinicName;
  final String consultationType;
  final String dayName;
  final int dayNumber;
  final String time;
  final String priority;
  final String paymentMethod;

  const AppointmentConfirmationScreen({
    super.key,
    required this.doctorName,
    required this.clinicName,
    required this.consultationType,
    required this.dayName,
    required this.dayNumber,
    required this.time,
    required this.priority,
    required this.paymentMethod,
  });

  Future<void> _saveAppointment() async {
    try {
      final appointmentService = getIt<AppointmentService>();
      
      final now = DateTime.now();
      final month = now.month.toString().padLeft(2, '0');
      final date = '$dayNumber/$month/2024';
      
      await appointmentService.saveAppointment(
        doctorName: doctorName,
        specialty: 'Especialidade',
        clinicName: clinicName,
        consultationType: consultationType,
        date: date,
        time: time,
        priority: priority,
        paymentMethod: paymentMethod,
      );
    } catch (e) {
      log('Erro ao salvar agendamento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    _saveAppointment();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          doctorName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // Ícone grande de calendário com checkmark
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 204, 205, 204),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 60,
                          color: Colors.green[600],
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Agendamento Confirmado
                  Text(
                    l10n.appointmentConfirmed,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Mensagem de confirmação
                  Text(
                    l10n.appointmentConfirmedMessage(doctorName),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Card com informações
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          l10n.clinic,
                          clinicName,
                          Icons.local_hospital_outlined,
                          isFirst: true,
                        ),
                        _buildDivider(context),
                        _buildInfoRow(
                          context,
                          l10n.doctor,
                          doctorName,
                          Icons.person_outline,
                        ),
                        _buildDivider(context),
                        _buildInfoRow(
                          context,
                          l10n.date,
                          '$dayName, ${l10n.day} $dayNumber',
                          Icons.calendar_today_outlined,
                        ),
                        _buildDivider(context),
                        _buildInfoRow(
                          context,
                          l10n.time,
                          time,
                          Icons.access_time_outlined,
                        ),
                        _buildDivider(context),
                        _buildInfoRow(
                          context,
                          l10n.type,
                          consultationType,
                          Icons.medical_services_outlined,
                        ),
                        _buildDivider(context),
                        _buildInfoRow(
                          context,
                          l10n.priority,
                          priority,
                          Icons.flag_outlined,
                        ),
                        _buildDivider(context),
                        _buildInfoRow(
                          context,
                          l10n.payment,
                          paymentMethod,
                          Icons.payment_outlined,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card de aviso
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.reminderMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão para voltar à tela de clínicas
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Volta para a tela de busca de clínicas
                  context.go('/search-clinics');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.backToClinics,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: isFirst ? 20 : 16,
        bottom: isLast ? 20 : 16,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      ),
    );
  }
}

