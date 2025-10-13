import 'package:go_router/go_router.dart';
import 'package:patientcareapp/screens/login_screen.dart';
import 'package:patientcareapp/screens/search_clinics_screen.dart';
import 'package:patientcareapp/screens/doctors_list_screen.dart';
import 'package:patientcareapp/screens/doctor_profile_screen.dart';
import 'package:patientcareapp/screens/appointment_confirmation_screen.dart';
import 'package:patientcareapp/screens/users_list_screen.dart';

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
          final data = state.extra as Map<String, dynamic>;
          return DoctorProfileScreen(
            doctor: data['doctor'],
            clinicName: data['clinicName'],
          );
        },
      ),
      GoRoute(
        path: '/appointment-confirmation',
        name: 'appointment-confirmation',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return AppointmentConfirmationScreen(
            doctorName: data['doctorName'],
            clinicName: data['clinicName'],
            consultationType: data['consultationType'],
            dayName: data['dayName'],
            dayNumber: data['dayNumber'],
            time: data['time'],
            priority: data['priority'],
            paymentMethod: data['paymentMethod'],
          );
        },
      ),
      GoRoute(
        path: '/users',
        name: 'users',
        builder: (context, state) => const UsersListScreen(),
      ),
    ],
  );
}

