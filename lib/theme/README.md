# 🎨 Guia de Uso do Tema PatientCare

## Paleta de Cores

### Cores Primárias Base
```dart
AppColors.primaryDark    // #05151A - Azul escuro profundo
AppColors.primaryGreen   // #07E233 - Verde vibrante
AppColors.primaryTeal    // #0C7076 - Verde-azulado
AppColors.primaryBlue    // #0706FC - Azul royal
AppColors.primaryCyan    // #6DA6C0 - Azul claro
AppColors.primaryNavy    // #294D61 - Azul marinho
```

## Como Usar as Cores

### 1. Usando Theme.of(context)
```dart
// Cor primária
Container(
  color: Theme.of(context).colorScheme.primary,
)

// Cor de fundo
Scaffold(
  backgroundColor: Theme.of(context).colorScheme.background,
)

// Texto
Text(
  'Texto',
  style: Theme.of(context).textTheme.bodyLarge,
)
```

### 2. Usando AppColors diretamente
```dart
// Light Mode
Container(
  color: AppColors.lightPrimary,
  child: Text(
    'Texto',
    style: TextStyle(color: AppColors.lightTextPrimary),
  ),
)

// Dark Mode
Container(
  color: AppColors.darkPrimary,
  child: Text(
    'Texto',
    style: TextStyle(color: AppColors.darkTextPrimary),
  ),
)
```

### 3. Cores por Categoria

#### Backgrounds
```dart
// Light Mode
AppColors.lightBackground      // Fundo principal
AppColors.lightSurface         // Superfície (Cards, Dialogs)
AppColors.lightCardBackground  // Fundo de cards

// Dark Mode
AppColors.darkBackground       // Fundo principal
AppColors.darkSurface          // Superfície (Cards, Dialogs)
AppColors.darkCardBackground   // Fundo de cards
```

#### Text Colors
```dart
// Light Mode
AppColors.lightTextPrimary     // Texto principal
AppColors.lightTextSecondary   // Texto secundário
AppColors.lightTextTertiary    // Texto terciário
AppColors.lightTextDisabled    // Texto desabilitado

// Dark Mode
AppColors.darkTextPrimary      // Texto principal
AppColors.darkTextSecondary    // Texto secundário
AppColors.darkTextTertiary     // Texto terciário
AppColors.darkTextDisabled     // Texto desabilitado
```

#### Status Colors
```dart
// Light Mode
AppColors.lightError    // Erros
AppColors.lightSuccess  // Sucesso
AppColors.lightWarning  // Avisos
AppColors.lightInfo     // Informações

// Dark Mode
AppColors.darkError     // Erros
AppColors.darkSuccess   // Sucesso
AppColors.darkWarning   // Avisos
AppColors.darkInfo      // Informações
```

### 4. Gradientes
```dart
// Light Mode - Primary Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: AppColors.lightPrimaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)

// Light Mode - Accent Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: AppColors.lightAccentGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)

// Dark Mode - Primary Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: AppColors.darkPrimaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)

// Dark Mode - Accent Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: AppColors.darkAccentGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)
```

## Exemplos Práticos

### Botão com cor primária
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Clique aqui'),
  // O tema já aplica a cor primária automaticamente
)
```

### Card com cor de superfície
```dart
Card(
  // O tema já aplica a cor de superfície automaticamente
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Conteúdo'),
  ),
)
```

### Container com gradiente primário
```dart
Container(
  height: 200,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: Theme.of(context).brightness == Brightness.light
          ? AppColors.lightPrimaryGradient
          : AppColors.darkPrimaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Center(
    child: Text(
      'Gradiente',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
```

### Container adaptável ao tema
```dart
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Texto',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),
)
```

## Boas Práticas

1. **Sempre use `Theme.of(context)`** quando possível para suporte automático a dark mode
2. **Use `AppColors` diretamente** apenas para cores específicas que não mudam com o tema
3. **Evite hardcoded colors** como `Colors.blue` ou `Color(0xFF000000)`
4. **Teste em ambos os modos** (light e dark) para garantir boa legibilidade
5. **Use os gradientes predefinidos** para consistência visual

## Testando o Tema

Para alternar entre light e dark mode no iOS Simulator:
1. Settings > Developer > Dark Appearance
2. Ou use o Control Center

Para alternar no app (adicione um botão de toggle):
```dart
// Em algum StatefulWidget
ThemeMode _themeMode = ThemeMode.system;

IconButton(
  icon: Icon(_themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
  onPressed: () {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    });
  },
)
```

