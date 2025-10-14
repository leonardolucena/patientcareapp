import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:patientcareapp/theme/theme_provider.dart';
import 'package:patientcareapp/presentation/providers/clinics_provider.dart';
import 'package:patientcareapp/presentation/widgets/floating_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Tela de busca de clínicas refatorada para usar arquitetura SOLID
/// Responsabilidade: APENAS UI - toda lógica está no ClinicsProvider
class SearchClinicsScreen extends StatefulWidget {
  const SearchClinicsScreen({super.key});

  @override
  State<SearchClinicsScreen> createState() => _SearchClinicsScreenState();
}

class _SearchClinicsScreenState extends State<SearchClinicsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega as clínicas ao iniciar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicsProvider>().loadAllClinics();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/');
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Configurar a cor da status bar baseada no tema
    final isDark = themeProvider.isDarkMode;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? const Color(0xFF1C1B1F) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Consumer<ClinicsProvider>(
                          builder: (context, provider, child) {
                            return Column(
                              children: [
                      // Título
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.searchClinic,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),

                            // Campo de busca
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: l10n.searchClinicHint,
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          provider.clearSearch();
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (value) {
                                provider.searchClinics(value);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Mapa Fictício
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                                    Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15),
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Linhas simulando ruas
                                  ..._buildStreetLines(),

                                  // Marcadores de clínicas
                                  if (!provider.isLoading && provider.error == null)
                                    ...provider.clinics.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final clinic = entry.value;
                                      // Posições fixas para as 3 clínicas
                                      final positions = [
                                        {'top': 0.2, 'left': 0.3},
                                        {'top': 0.5, 'left': 0.6},
                                        {'top': 0.7, 'left': 0.4},
                                      ];
                                      final position = positions[index % positions.length];

                                      return Positioned(
                                        top: MediaQuery.of(context).size.height * position['top']!,
                                        left: MediaQuery.of(context).size.width * position['left']!,
                                        child: GestureDetector(
                                          onTap: () {
                                            _showClinicInfo(clinic, l10n);
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.error,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor
                                                          .withValues(alpha: 0.3),
                                                      blurRadius: 6,
                                                      offset: const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.local_hospital,
                                                  color: Theme.of(context).colorScheme.onError,
                                                  size: 24,
                                                ),
                                              ),
                                              Container(
                                                width: 3,
                                                height: 12,
                                                color: Theme.of(context).colorScheme.error,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),

                                  // Loading indicator
                                  if (provider.isLoading)
                                    const Center(child: CircularProgressIndicator()),

                                  // Error indicator
                                  if (provider.error != null)
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 48,
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            provider.error!,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Botão de localização
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: FloatingActionButton(
                                      mini: true,
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      foregroundColor: Theme.of(context).colorScheme.primary,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.centeringLocation),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.my_location),
                                    ),
                                  ),

                                  // Indicador "Mapa Fictício" no topo
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        l10n.fakeMap,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80), // Espaço para a nav bar flutuante
                    ],
                  );
                },
              ),

              // Botão de logout no canto superior direito
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                    tooltip: l10n.logout,
                    onPressed: () => _showLogoutDialog(context, l10n),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    ),
    Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: const FloatingNavBar(currentIndex: 0),
    ),
  ],
        ),
      ),
    );
  }

  List<Widget> _buildStreetLines() {
    final lineColor = Theme.of(context).colorScheme.outline.withValues(alpha: 0.3);
    return [
      // Linhas horizontais
      Positioned(
        top: 100,
        left: 0,
        right: 0,
        child: Container(height: 2, color: lineColor),
      ),
      Positioned(
        top: 200,
        left: 0,
        right: 0,
        child: Container(height: 2, color: lineColor),
      ),
      Positioned(
        top: 300,
        left: 0,
        right: 0,
        child: Container(height: 2, color: lineColor),
      ),
      // Linhas verticais
      Positioned(
        top: 0,
        bottom: 0,
        left: 100,
        child: Container(width: 2, color: lineColor),
      ),
      Positioned(
        top: 0,
        bottom: 0,
        left: 200,
        child: Container(width: 2, color: lineColor),
      ),
      Positioned(
        top: 0,
        bottom: 0,
        left: 300,
        child: Container(width: 2, color: lineColor),
      ),
    ];
  }

  void _showClinicInfo(clinic, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_hospital,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      clinic.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      clinic.address,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.directions_walk,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    clinic.distance,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navega para a tela de médicos passando o nome da clínica
                    context.push('/doctors/${Uri.encodeComponent(clinic.name)}');
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(l10n.scheduleAppointment),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
