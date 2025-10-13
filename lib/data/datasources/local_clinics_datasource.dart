import 'package:patientcareapp/data/models/clinic_model.dart';

/// Datasource local com dados fictícios de clínicas
class LocalClinicsDatasource {
  static final List<ClinicModel> _clinics = [
    const ClinicModel(
      id: 'clinic_001',
      name: 'Clínica São Paulo',
      address: 'Av. Paulista, 1000',
      distance: '2.3 km',
      latitude: -23.561684,
      longitude: -46.655981,
    ),
    const ClinicModel(
      id: 'clinic_002',
      name: 'Hospital Santa Maria',
      address: 'Rua Augusta, 500',
      distance: '3.5 km',
      latitude: -23.561234,
      longitude: -46.654321,
    ),
    const ClinicModel(
      id: 'clinic_003',
      name: 'Clínica Vida Saudável',
      address: 'Av. Brasil, 250',
      distance: '1.8 km',
      latitude: -23.560987,
      longitude: -46.656789,
    ),
  ];

  List<ClinicModel> getAllClinics() => _clinics;

  ClinicModel? getClinicById(String id) {
    try {
      return _clinics.firstWhere((clinic) => clinic.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ClinicModel> searchClinicsByName(String name) {
    final lowerName = name.toLowerCase();
    return _clinics
        .where((clinic) => clinic.name.toLowerCase().contains(lowerName))
        .toList();
  }

  List<ClinicModel> getNearbyClinicsByDistance(double maxDistanceKm) {
    return _clinics
        .where((clinic) {
          final distance = double.tryParse(
            clinic.distance.replaceAll(' km', '').replaceAll(',', '.'),
          ) ?? 0;
          return distance <= maxDistanceKm;
        })
        .toList();
  }
}

