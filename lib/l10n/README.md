# Sistema de Internacionalização (l10n)

Este projeto utiliza o sistema de internacionalização nativo do Flutter para suportar múltiplos idiomas.

## Idiomas Suportados

- **Português (pt_BR)** - Idioma padrão
- **English (en_US)**

## Como Funciona

### Arquivos ARB

Os arquivos de tradução estão localizados em `lib/l10n/`:
- `app_pt.arb` - Traduções em português
- `app_en.arb` - Traduções em inglês

### Usando Traduções no Código

Para usar as traduções em qualquer tela:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// No build method:
final l10n = AppLocalizations.of(context)!;

// Usando as traduções:
Text(l10n.appTitle)
Text(l10n.welcomeBack)
```

### Adicionando Novas Traduções

1. Adicione a chave no arquivo `app_pt.arb`:
```json
{
  "novaChave": "Texto em português",
  "@novaChave": {
    "description": "Descrição da tradução"
  }
}
```

2. Adicione a mesma chave no arquivo `app_en.arb`:
```json
{
  "novaChave": "Text in English"
}
```

3. Execute `flutter pub get` para gerar o código

4. Use no código:
```dart
Text(l10n.novaChave)
```

### Traduções com Parâmetros

Para textos que precisam de parâmetros dinâmicos:

**No arquivo ARB:**
```json
{
  "mensagemComParametro": "Olá, {nome}!",
  "@mensagemComParametro": {
    "description": "Mensagem de saudação",
    "placeholders": {
      "nome": {
        "type": "String",
        "example": "João"
      }
    }
  }
}
```

**No código:**
```dart
Text(l10n.mensagemComParametro('Maria'))
```

## Mudando o Idioma

O aplicativo possui um `LocaleProvider` para gerenciar mudanças de idioma:

```dart
final localeProvider = Provider.of<LocaleProvider>(context);
localeProvider.setLocale(Locale('en', 'US')); // Mudar para inglês
localeProvider.setLocale(Locale('pt', 'BR')); // Mudar para português
```

O botão de mudança de idioma está disponível na tela de login.

## Estrutura de Arquivos

```
lib/
├── l10n/
│   ├── app_pt.arb          # Traduções em português
│   ├── app_en.arb          # Traduções em inglês
│   └── README.md           # Esta documentação
├── providers/
│   └── locale_provider.dart # Gerenciador de idioma
└── main.dart               # Configuração do l10n
```

## Regenerando os Arquivos

Após modificar os arquivos ARB, execute:

```bash
flutter pub get
```

Isso regerará os arquivos de localização automaticamente.

