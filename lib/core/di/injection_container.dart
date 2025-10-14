import 'package:get_it/get_it.dart';
import 'package:patientcareapp/core/network/api_gateway.dart';
import 'package:patientcareapp/core/services/auth_service.dart';
import 'package:patientcareapp/core/services/appointment_service.dart';
import 'package:patientcareapp/core/services/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:patientcareapp/data/datasources/local_clinics_datasource.dart';
import 'package:patientcareapp/data/datasources/local_doctors_datasource.dart';
import 'package:patientcareapp/data/datasources/local_reviews_datasource.dart';
import 'package:patientcareapp/data/datasources/local_specialties_datasource.dart';
import 'package:patientcareapp/data/datasources/remote_users_datasource.dart';
import 'package:patientcareapp/data/repositories/appointment_repository_impl.dart';
import 'package:patientcareapp/data/repositories/clinic_repository_impl.dart';
import 'package:patientcareapp/data/repositories/doctor_repository_impl.dart';
import 'package:patientcareapp/data/repositories/review_repository_impl.dart';
import 'package:patientcareapp/data/repositories/specialty_repository_impl.dart';
import 'package:patientcareapp/data/repositories/user_repository_impl.dart';
import 'package:patientcareapp/data/repositories/favorites_repository_impl.dart';
import 'package:patientcareapp/domain/repositories/appointment_repository.dart';
import 'package:patientcareapp/domain/repositories/favorites_repository.dart';
import 'package:patientcareapp/domain/repositories/clinic_repository.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';
import 'package:patientcareapp/domain/repositories/review_repository.dart';
import 'package:patientcareapp/domain/repositories/specialty_repository.dart';
import 'package:patientcareapp/domain/repositories/user_repository.dart';
import 'package:patientcareapp/domain/usecases/create_appointment_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_all_clinics_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_all_doctors_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_all_specialties_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_all_users_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_doctor_reviews_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_doctors_by_specialty_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_clinics_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_doctors_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_users_usecase.dart';

/// Container de injeção de dependências
/// Implementa o Dependency Inversion Principle (DIP)
/// Usa GetIt como service locator
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // ==================== SERVICES ====================
  
  // AuthService (Singleton)
  final authService = AuthService();
  await authService.initialize();
  getIt.registerSingleton<AuthService>(authService);

  // AppointmentService (Singleton)
  final appointmentService = AppointmentService();
  await appointmentService.initialize();
  getIt.registerSingleton<AppointmentService>(appointmentService);

  // SharedPreferences (Singleton)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // FavoritesService (Singleton)
  getIt.registerLazySingleton<FavoritesService>(
    () => FavoritesService(getIt()),
  );

  // ==================== NETWORK ====================
  
  // API Gateway (Singleton)
  getIt.registerLazySingleton<ApiGateway>(
    () => ApiGateway(),
  );

  // ==================== DATA SOURCES ====================
  
  // Datasources Locais (Singleton - dependem do Remote para buscar nomes da API)
  getIt.registerLazySingleton<LocalDoctorsDatasource>(
    () => LocalDoctorsDatasource(getIt<RemoteUsersDatasource>()),
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

  // Datasources Remotos (Singleton - dependem do ApiGateway)
  getIt.registerLazySingleton<RemoteUsersDatasource>(
    () => RemoteUsersDatasource(getIt()),
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
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt()),
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
  
  getIt.registerFactory(
    () => GetAllUsersUseCase(getIt()),
  );
  
  getIt.registerFactory(
    () => SearchUsersUseCase(getIt()),
  );
}

