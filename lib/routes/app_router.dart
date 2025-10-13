import 'package:go_router/go_router.dart';
import 'package:patientcareapp/screens/login_screen.dart';
import 'package:patientcareapp/screens/search_clinics_screen.dart';
import 'package:patientcareapp/screens/doctors_list_screen.dart';
import 'package:patientcareapp/screens/doctor_profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/search-clinics',
        name: 'search-clinics',
        builder: (context, state) => const SearchClinicsScreen(),
      ),
      GoRoute(
        path: '/doctors/:clinicName',
        name: 'doctors',
        builder: (context, state) {
          final clinicName = state.pathParameters['clinicName'] ?? 'Clínica';
          return DoctorsListScreen(clinicName: clinicName);
        },
      ),
      GoRoute(
        path: '/doctor-profile',
        name: 'doctor-profile',
        builder: (context, state) {
          final doctor = state.extra as Map<String, dynamic>;
          return DoctorProfileScreen(doctor: doctor);
        },
      ),
    ],
  );
}

