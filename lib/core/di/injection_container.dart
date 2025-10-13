import 'package:get_it/get_it.dart';
import 'package:patientcareapp/data/datasources/local_clinics_datasource.dart';
import 'package:patientcareapp/data/datasources/local_doctors_datasource.dart';
import 'package:patientcareapp/data/datasources/local_reviews_datasource.dart';
import 'package:patientcareapp/data/datasources/local_specialties_datasource.dart';
import 'package:patientcareapp/data/repositories/appointment_repository_impl.dart';
import 'package:patientcareapp/data/repositories/clinic_repository_impl.dart';
import 'package:patientcareapp/data/repositories/doctor_repository_impl.dart';
import 'package:patientcareapp/data/repositories/review_repository_impl.dart';
import 'package:patientcareapp/data/repositories/specialty_repository_impl.dart';
import 'package:patientcareapp/domain/repositories/appointment_repository.dart';
import 'package:patientcareapp/domain/repositories/clinic_repository.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';
import 'package:patientcareapp/domain/repositories/review_repository.dart';
import 'package:patientcareapp/domain/repositories/specialty_repository.dart';
import 'package:patientcareapp/domain/usecases/create_appointment_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_all_clinics_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_all_doctors_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_all_specialties_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_doctor_reviews_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_doctors_by_specialty_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_clinics_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_doctors_usecase.dart';

/// Container de injeção de dependências
/// Implementa o Dependency Inversion Principle (DIP)
/// Usa GetIt como service locator
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // ==================== DATA SOURCES ====================
  
  // Datasources (Singleton - uma única instância)
  getIt.registerLazySingleton<LocalDoctorsDatasource>(
    () => LocalDoctorsDatasource(),
  );
  
  getIt.registerLazySingleton<LocalClinicsDatasource>(
    () => LocalClinicsDatasource(),
  );
  
  getIt.registerLazySingleton<LocalSpecialtiesDatasource>(
    () => LocalSpecialtiesDatasource(),
  );
  
  getIt.registerLazySingleton<LocalReviewsDatasource>(
    () => LocalReviewsDatasource(),
  );

  // ==================== REPOSITORIES ====================
  
  // Repositories (Singleton - dependem dos datasources)
  getIt.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton<ClinicRepository>(
    () => ClinicRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton<SpecialtyRepository>(
    () => SpecialtyRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(),
  );

  // ==================== USE CASES ====================
  
  // Use Cases (Factory - nova instância a cada chamada)
  getIt.registerFactory(
    () => GetAllDoctorsUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => GetDoctorsBySpecialtyUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => SearchDoctorsUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => GetAllClinicsUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => SearchClinicsUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => GetAllSpecialtiesUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => GetDoctorReviewsUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => CreateAppointmentUseCase(getIt()),
  );
}

