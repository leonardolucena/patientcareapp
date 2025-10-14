import 'package:go_router/go_router.dart';
import 'package:patientcareapp/screens/login_screen.dart';
import 'package:patientcareapp/screens/register_screen.dart';
import 'package:patientcareapp/screens/forgot_password_screen.dart';
import 'package:patientcareapp/screens/edit_profile_screen.dart';
import 'package:patientcareapp/screens/search_clinics_screen.dart';
import 'package:patientcareapp/screens/profile_screen.dart';
import 'package:patientcareapp/screens/doctors_list_screen.dart';
import 'package:patientcareapp/screens/doctor_profile_screen.dart';
import 'package:patientcareapp/screens/appointment_confirmation_screen.dart';
import 'package:patientcareapp/screens/users_list_screen.dart';
import 'package:patientcareapp/screens/favorites_screen.dart';
import 'package:patientcareapp/screens/medical_history_screen.dart';
import 'package:patientcareapp/screens/add_medical_record_screen.dart';

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
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/search-clinics',
        name: 'search-clinics',
        builder: (context, state) => const SearchClinicsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
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
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/medical-history',
        name: 'medical-history',
        builder: (context, state) => const MedicalHistoryScreen(),
      ),
      GoRoute(
        path: '/medical-history/add',
        name: 'add-medical-record',
        builder: (context, state) => const AddMedicalRecordScreen(),
      ),
    ],
  );
}

