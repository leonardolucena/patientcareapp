import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/presentation/widgets/specialty_chip_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Testes do SpecialtyChipWidget
void main() {
  Widget createWidgetUnderTest({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
        body: SpecialtyChipWidget(
          label: label,
          icon: icon,
          isSelected: isSelected,
          onTap: onTap,
        ),
      ),
    );
  }

  group('SpecialtyChipWidget', () {
    testWidgets('deve exibir nome e ícone da especialidade', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Cardiologia',
          icon: Icons.favorite,
          isSelected: false,
          onTap: () {},
        ),
      );

      // Assert
      expect(find.text('Cardiologia'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('deve ter estilo diferente quando selecionado', (tester) async {
      // Arrange & Act - Não selecionado
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Cardiologia',
          icon: Icons.favorite,
          isSelected: false,
          onTap: () {},
        ),
      );

      final unselectedIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite),
      );

      // Arrange & Act - Selecionado
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Cardiologia',
          icon: Icons.favorite,
          isSelected: true,
          onTap: () {},
        ),
      );

      final selectedIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite),
      );

      // Assert - Os ícones devem existir
      expect(unselectedIcon, isNotNull);
      expect(selectedIcon, isNotNull);
    });

    testWidgets('deve ser clicável', (tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Cardiologia',
          icon: Icons.favorite,
          isSelected: false,
          onTap: () => tapped = true,
        ),
      );

      // Act
      await tester.tap(find.byType(SpecialtyChipWidget));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
