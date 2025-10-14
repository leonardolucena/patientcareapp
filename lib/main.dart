import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:patientcareapp/routes/app_router.dart';
import 'package:patientcareapp/theme/app_theme.dart';
import 'package:patientcareapp/theme/theme_provider.dart';
import 'package:patientcareapp/providers/locale_provider.dart';
import 'package:patientcareapp/presentation/providers/doctors_provider.dart';
import 'package:patientcareapp/presentation/providers/clinics_provider.dart';
import 'package:patientcareapp/presentation/providers/reviews_provider.dart';
import 'package:patientcareapp/presentation/providers/users_provider.dart';
import 'package:patientcareapp/presentation/providers/favorites_provider.dart';
import 'package:patientcareapp/presentation/providers/medical_history_provider.dart';
import 'package:patientcareapp/presentation/providers/reminder_provider.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:patientcareapp/data/models/local_user_model.dart';
import 'package:patientcareapp/data/models/appointment_saved_model.dart';
import 'package:patientcareapp/data/models/medical_record_model.dart';
import 'package:patientcareapp/data/models/reminder_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Hive
  await Hive.initFlutter();
  Hive.registerAdapter(LocalUserModelAdapter());
  Hive.registerAdapter(AppointmentSavedModelAdapter());
  Hive.registerAdapter(MedicalRecordModelAdapter());
  Hive.registerAdapter(ReminderModelAdapter());
  
  // Inicializa o Dependency Injection (inclui AuthService)
  await initializeDependencies();
  
  runApp(
    MultiProvider(
      providers: [
        // Providers globais
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        
        // Providers de features (arquitetura SOLID)
        ChangeNotifierProvider(create: (_) => DoctorsProvider()),
        ChangeNotifierProvider(create: (_) => ClinicsProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(getIt())),
        ChangeNotifierProvider(create: (_) => MedicalHistoryProvider(getIt())),
        ChangeNotifierProvider(create: (_) => ReminderProvider(getIt())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    // Configurar a cor da status bar baseada no tema
    final isDark = themeProvider.isDarkMode;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? const Color(0xFF1C1B1F) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
    
    return MaterialApp.router(
      title: 'PatientCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
      routerConfig: AppRouter.router,
    );
  }
}
