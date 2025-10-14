import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:patientcareapp/theme/theme_provider.dart';
import 'package:patientcareapp/presentation/widgets/floating_nav_bar.dart';
import 'package:patientcareapp/core/services/appointment_service.dart';
import 'package:patientcareapp/core/services/auth_service.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AppointmentService _appointmentService;
  late AuthService _authService;

  String _userName = 'Usuário';
  int _userAge = 32;
  final String _userAvatar = '👤';
  
  Map<String, int> _statistics = {};

  @override
  void initState() {
    super.initState();
    _appointmentService = getIt<AppointmentService>();
    _authService = getIt<AuthService>();
    _loadUserData();
    _loadStatistics();
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

  Future<void> _loadStatistics() async {
    await _appointmentService.reopenFutureCompletedAppointments();
    await _appointmentService.updateExpiredAppointments();
    
    if (mounted) {
      setState(() {
        _statistics = _appointmentService.getStatistics();
      });
    }
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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(context, l10n),
              const SizedBox(height: 16),
              _buildDashboard(context, l10n),
              const SizedBox(height: 20),
              _buildProfileActions(context, l10n),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: const FloatingNavBar(currentIndex: 1),
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

  Widget _buildProfileActions(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_month_rounded, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Minhas Consultas'),
                  subtitle: Text('${_statistics['open'] ?? 0} agendadas'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onTap: () => context.push('/appointments'),
                ),
                Divider(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                ListTile(
                  leading: Icon(Icons.favorite_rounded, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Meus Favoritos'),
                  subtitle: const Text('Médicos e clínicas favoritos'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onTap: () => context.push('/favorites'),
                ),
                Divider(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                ListTile(
                  leading: Icon(Icons.medical_information_rounded, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Histórico Médico'),
                  subtitle: const Text('Consultas, exames e medicações'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onTap: () => context.push('/medical-history'),
                ),
                Divider(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                ListTile(
                  leading: Icon(Icons.notifications_active_rounded, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Lembretes'),
                  subtitle: const Text('Lembretes de consultas'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onTap: () => context.push('/reminders'),
                ),
              ],
            ),
          ),
        ],
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

}
