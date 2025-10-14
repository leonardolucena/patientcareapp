import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:patientcareapp/theme/theme_provider.dart';
import 'package:patientcareapp/presentation/widgets/floating_nav_bar.dart';
import 'package:patientcareapp/core/services/appointment_service.dart';
import 'package:patientcareapp/core/services/auth_service.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:patientcareapp/data/models/appointment_saved_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AppointmentService _appointmentService;
  late AuthService _authService;

  String _userName = 'Usuário';
  int _userAge = 32;
  final String _userAvatar = '👤';
  
  List<AppointmentSavedModel> _openAppointments = [];
  List<AppointmentSavedModel> _closedAppointments = [];
  Map<String, int> _statistics = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _appointmentService = getIt<AppointmentService>();
    _authService = getIt<AuthService>();
    _loadUserData();
    _loadAppointments();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _userName = user.name ?? user.email.split('@')[0];
        _userAge = user.age ?? 32;
      });
    }
  }

  Future<void> _loadAppointments() async {
    // Primeiro: reabre consultas futuras que foram marcadas incorretamente
    await _appointmentService.reopenFutureCompletedAppointments();
    
    // Segundo: marca consultas passadas como concluídas
    await _appointmentService.updateExpiredAppointments();
    
    setState(() {
      _openAppointments = _appointmentService.getOpenAppointments();
      _closedAppointments = _appointmentService.getClosedAppointments();
      _statistics = _appointmentService.getStatistics();
    });
  }

  Future<void> _showCancelDialog(AppointmentSavedModel appointment, AppLocalizations l10n) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelAppointment),
        content: Text(l10n.cancelAppointmentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirmCancellation),
          ),
        ],
      ),
    );

    if (result == true) {
      await _appointmentService.cancelAppointment(appointment.id);
      _loadAppointments();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.appointmentCancelled),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = themeProvider.isDarkMode;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: isDark ? const Color(0xFF1C1B1F) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context, l10n),
                const SizedBox(height: 16),
                _buildDashboard(context, l10n),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildAppointmentsSection(context, l10n),
                ),
                const SizedBox(height: 80), // Espaço para a nav bar flutuante
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: const FloatingNavBar(currentIndex: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(_userAvatar, style: const TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_userAge ${l10n.years}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () {
                  context.push('/edit-profile').then((_) {
                    // Recarrega os dados quando voltar da edição
                    _loadUserData();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            l10n.statistics,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildStatCard(context, icon: Icons.calendar_month_rounded, title: l10n.totalAppointments, value: _statistics['total']?.toString() ?? '0', color: Colors.blue),
              const SizedBox(width: 12),
              _buildStatCard(context, icon: Icons.check_circle_rounded, title: l10n.completed, value: _statistics['completed']?.toString() ?? '0', color: Colors.green),
              const SizedBox(width: 12),
              _buildStatCard(context, icon: Icons.medical_services_rounded, title: l10n.doctor, value: _statistics['doctors']?.toString() ?? '0', color: Colors.orange),
              const SizedBox(width: 12),
              _buildStatCard(context, icon: Icons.schedule_rounded, title: l10n.upcoming, value: _statistics['open']?.toString() ?? '0', color: Colors.purple),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String title, required String value, required Color color}) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 10,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(l10n.myAppointments, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            tabs: [
              Tab(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(child: Text(l10n.open)),
                ),
              ),
              Tab(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(child: Text(l10n.closed)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentsList(_openAppointments, isOpen: true, l10n: l10n),
              _buildAppointmentsList(_closedAppointments, isOpen: false, l10n: l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsList(List<AppointmentSavedModel> appointments, {required bool isOpen, required AppLocalizations l10n}) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isOpen ? Icons.calendar_today_rounded : Icons.check_circle_outline_rounded, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(isOpen ? l10n.noOpenAppointments : l10n.noClosedAppointments, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      itemCount: appointments.length,
      itemBuilder: (context, index) => _buildAppointmentCard(appointments[index], isOpen: isOpen, l10n: l10n),
    );
  }

  Widget _buildAppointmentCard(AppointmentSavedModel appointment, {required bool isOpen, required AppLocalizations l10n}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.local_hospital_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.doctorName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(appointment.specialty, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isOpen 
                    ? (appointment.consultationType == 'Online' ? Colors.green : Colors.blue) 
                    : (appointment.isCancelled ? Colors.red : Colors.green)).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isOpen 
                    ? appointment.consultationType 
                    : (appointment.isCancelled ? l10n.cancelled : 'Concluído'),
                  style: TextStyle(
                    color: isOpen 
                      ? (appointment.consultationType == 'Online' ? Colors.green : Colors.blue) 
                      : (appointment.isCancelled ? Colors.red : Colors.green),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text('${appointment.date} - ${appointment.time}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Expanded(child: Text(appointment.clinicName, style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          // Botão de cancelar apenas para consultas abertas
          if (isOpen && !appointment.isCancelled) ...[
            const SizedBox(height: 12),
            Divider(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(appointment, l10n),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: Text(l10n.cancelAppointment),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
