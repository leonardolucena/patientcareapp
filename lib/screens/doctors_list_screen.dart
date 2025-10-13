import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:patientcareapp/core/services/specialty_translation_service.dart';
import 'package:patientcareapp/presentation/providers/doctors_provider.dart';
import 'package:patientcareapp/presentation/widgets/doctor_card_widget.dart';
import 'package:patientcareapp/presentation/widgets/specialty_chip_widget.dart';

/// Tela de lista de médicos refatorada para usar arquitetura SOLID
/// Responsabilidade: APENAS UI - toda lógica está no DoctorsProvider
class DoctorsListScreen extends StatefulWidget {
  final String clinicName;

  const DoctorsListScreen({
    super.key,
    required this.clinicName,
  });

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega os médicos ao iniciar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorsProvider>().loadAllDoctors();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Função para obter especialidades com base no l10n
  List<Map<String, dynamic>> _getSpecialties(AppLocalizations l10n) {
    return [
      {'name': l10n.all, 'nameKey': 'Todos', 'icon': Icons.medical_services},
      {'name': l10n.cardiology, 'nameKey': 'Cardiologia', 'icon': Icons.favorite},
      {'name': l10n.dermatology, 'nameKey': 'Dermatologia', 'icon': Icons.face},
      {'name': l10n.orthopedics, 'nameKey': 'Ortopedia', 'icon': Icons.accessibility_new},
      {'name': l10n.pediatrics, 'nameKey': 'Pediatria', 'icon': Icons.child_care},
      {'name': l10n.neurology, 'nameKey': 'Neurologia', 'icon': Icons.psychology},
      {'name': l10n.ophthalmology, 'nameKey': 'Oftalmologia', 'icon': Icons.remove_red_eye},
      {'name': l10n.gynecology, 'nameKey': 'Ginecologia', 'icon': Icons.pregnant_woman},
      {'name': l10n.psychiatry, 'nameKey': 'Psiquiatria', 'icon': Icons.mood},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final specialties = _getSpecialties(l10n);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.clinicName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<DoctorsProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              const SizedBox(height: 16),

              // Banner com foto da médica
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Texto e botão
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.healthBanner,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.featureInDevelopment),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                l10n.learnMore,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Foto da médica
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '👩‍⚕️',
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Lista de especialidades (rolagem horizontal)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: specialties.length,
                  itemBuilder: (context, index) {
                    final specialty = specialties[index];
                    final isSelected = provider.selectedSpecialty == specialty['nameKey'];

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SpecialtyChipWidget(
                        label: specialty['name'],
                        icon: specialty['icon'],
                        isSelected: isSelected,
                        onTap: () {
                          provider.filterBySpecialty(specialty['nameKey']);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Campo de busca por nome
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchDoctorByName,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.searchDoctors('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    provider.searchDoctors(value);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Título da lista de médicos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.selectedSpecialty == 'Todos'
                          ? l10n.allDoctors
                          : SpecialtyTranslationService.translateSpecialty(
                              provider.selectedSpecialty,
                              l10n,
                            ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.availableCount(provider.doctors.length),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Lista de médicos (somente ela rola)
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  provider.error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => provider.loadAllDoctors(),
                                  child: const Text('Tentar novamente'),
                                ),
                              ],
                            ),
                          )
                        : provider.doctors.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum médico encontrado',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                itemCount: provider.doctors.length,
                                itemBuilder: (context, index) {
                                  final doctor = provider.doctors[index];
                                  return DoctorCardWidget(
                                    doctor: doctor,
                                    onTap: () {
                                      context.push('/doctor-profile', extra: {
                                        'doctor': {
                                          'id': doctor.id,
                                          'name': doctor.name,
                                          'specialty': doctor.specialty,
                                          'rating': doctor.rating,
                                          'experience': doctor.experience,
                                          'price': doctor.price,
                                          'image': doctor.image,
                                        },
                                        'clinicName': widget.clinicName,
                                      });
                                    },
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}
