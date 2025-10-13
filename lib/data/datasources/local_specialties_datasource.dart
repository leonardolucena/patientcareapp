import 'package:flutter/material.dart';
import 'package:patientcareapp/data/models/specialty_model.dart';

/// Datasource local com dados de especialidades
class LocalSpecialtiesDatasource {
  static final List<SpecialtyModel> _specialties = [
    const SpecialtyModel(
      id: 'spec_000',
      nameKey: 'all',
      icon: Icons.medical_services,
    ),
    const SpecialtyModel(
      id: 'spec_001',
      nameKey: 'cardiology',
      icon: Icons.favorite,
    ),
    const SpecialtyModel(
      id: 'spec_002',
      nameKey: 'dermatology',
      icon: Icons.face,
    ),
    const SpecialtyModel(
      id: 'spec_003',
      nameKey: 'orthopedics',
      icon: Icons.accessibility_new,
    ),
    const SpecialtyModel(
      id: 'spec_004',
      nameKey: 'pediatrics',
      icon: Icons.child_care,
    ),
    const SpecialtyModel(
      id: 'spec_005',
      nameKey: 'neurology',
      icon: Icons.psychology,
    ),
    const SpecialtyModel(
      id: 'spec_006',
      nameKey: 'ophthalmology',
      icon: Icons.remove_red_eye,
    ),
    const SpecialtyModel(
      id: 'spec_007',
      nameKey: 'gynecology',
      icon: Icons.pregnant_woman,
    ),
    const SpecialtyModel(
      id: 'spec_008',
      nameKey: 'psychiatry',
      icon: Icons.mood,
    ),
  ];

  List<SpecialtyModel> getAllSpecialties() => _specialties;

  SpecialtyModel? getSpecialtyById(String id) {
    try {
      return _specialties.firstWhere((spec) => spec.id == id);
    } catch (e) {
      return null;
    }
  }

  SpecialtyModel? getSpecialtyByNameKey(String nameKey) {
    try {
      return _specialties.firstWhere((spec) => spec.nameKey == nameKey);
    } catch (e) {
      return null;
    }
  }
}

