import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/presentation/widgets/doctor_card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Testes do DoctorCardWidget
/// 
/// Testa se o widget renderiza corretamente as informações do médico
void main() {
  late DoctorModel testDoctor;

  setUp(() {
    testDoctor = const DoctorModel(
      id: '1',
      name: 'Dr. Test',
      specialty: 'Cardiologia',
      rating: 4.5,
      experience: '10 anos',
      price: 'R\$ 200',
      image: '👨‍⚕️',
    );
  });

  Widget createWidgetUnderTest(DoctorModel doctor, VoidCallback onTap) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
      ],
      home: Scaffold(
        body: DoctorCardWidget(
          doctor: doctor,
          onTap: onTap,
        ),
      ),
    );
  }

  group('DoctorCardWidget', () {
    testWidgets('deve exibir informações básicas do médico', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(testDoctor, () {}));

      // Assert
      expect(find.text('Dr. Test'), findsOneWidget);
      expect(find.text('👨‍⚕️'), findsOneWidget);
      expect(find.text('10 anos'), findsOneWidget);
      expect(find.text('R\$ 200'), findsOneWidget);
    });

    testWidgets('deve exibir rating com ícone de estrela', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(testDoctor, () {}));

      // Assert
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('deve ser clicável quando onTap é fornecido', (tester) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(testDoctor, () => tapped = true),
      );
      
      // Toca no botão "Ver" em vez de no card todo
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('deve exibir ícone de experiência', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(testDoctor, () {}));

      // Assert
      expect(find.byIcon(Icons.work_outline), findsOneWidget);
    });
  });
}
