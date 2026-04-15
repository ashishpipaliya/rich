---
name: localization
description: "Manage Flutter app internationalization with ARB files, supporting multiple languages and locale-aware formatting."
---

# Flutter Localization (l10n)

## Role
Manage app internationalization with ARB files, supporting multiple languages and providing utilities for easy string management.

---

## Dependencies

```bash
flutter pub add flutter_localizations intl
```

> `flutter_localizations` is an SDK package — it doesn't need a version. `intl` version is resolved automatically by pub.

---

## Setup

### l10n.yaml Configuration

```yaml
# l10n.yaml (project root)
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/generated
synthetic-package: false
output-class: AppLocalizations
nullable-getter: false
untranslated-messages-file: untranslated_messages.json
preferred-supported-locales:
  - en
```

### Main.dart Setup

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),    // English
        Locale('es'),    // Spanish
        Locale('fr'),    // French
        Locale('de'),    // German
        Locale('hi'),    // Hindi
        Locale('ar'),    // Arabic
      ],
      home: const HomePage(),
    );
  }
}
```

---

## ARB File Structure

### Base Template (app_en.arb)

```json
{
  "@@locale": "en",
  "@@last_modified": "2024-01-15T10:30:00Z",
  
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message shown on home screen",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Shows item count with proper pluralization",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },
  
  "genderMessage": "{gender, select, male{He} female{She} other{They}} liked this",
  "@genderMessage": {
    "description": "Gender-specific message",
    "placeholders": {
      "gender": {
        "type": "String"
      }
    }
  },
  
  "lastUpdated": "Last updated: {date}",
  "@lastUpdated": {
    "description": "Shows last update timestamp",
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMMd"
      }
    }
  },
  
  "price": "Price: {amount}",
  "@price": {
    "description": "Product price display",
    "placeholders": {
      "amount": {
        "type": "double",
        "format": "currency",
        "optionalParameters": {
          "symbol": "$",
          "decimalDigits": 2
        }
      }
    }
  },
  
  "actionSave": "Save",
  "@actionSave": {
    "description": "Save action button label"
  },
  
  "actionCancel": "Cancel",
  "@actionCancel": {
    "description": "Cancel action button label"
  },
  
  "actionDelete": "Delete",
  "@actionDelete": {
    "description": "Delete action button label"
  },
  
  "errorNetwork": "Network error. Please check your connection.",
  "@errorNetwork": {
    "description": "Network error message"
  },
  
  "errorUnknown": "Something went wrong. Please try again.",
  "@errorUnknown": {
    "description": "Generic error message"
  }
}
```

### Spanish Translation (app_es.arb)

```json
{
  "@@locale": "es",
  
  "appTitle": "Mi App",
  "welcomeMessage": "¡Bienvenido, {name}!",
  "itemCount": "{count, plural, =0{Sin elementos} =1{1 elemento} other{{count} elementos}}",
  "genderMessage": "{gender, select, male{Él} female{Ella} other{Ellos}} les gustó esto",
  "lastUpdated": "Última actualización: {date}",
  "price": "Precio: {amount}",
  "actionSave": "Guardar",
  "actionCancel": "Cancelar",
  "actionDelete": "Eliminar",
  "errorNetwork": "Error de red. Por favor verifica tu conexión.",
  "errorUnknown": "Algo salió mal. Por favor intenta de nuevo."
}
```

### Hindi Translation (app_hi.arb)

```json
{
  "@@locale": "hi",
  
  "appTitle": "मेरा ऐप",
  "welcomeMessage": "स्वागत है, {name}!",
  "itemCount": "{count, plural, =0{कोई आइटम नहीं} =1{1 आइटम} other{{count} आइटम}}",
  "actionSave": "सहेजें",
  "actionCancel": "रद्द करें",
  "actionDelete": "हटाएं"
}
```

---

## Localization Service

```dart
// core/localization/localization_service.dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../generated/app_localizations.dart';

@lazySingleton
class LocalizationService {
  late AppLocalizations _l10n;
  late Locale _locale;

  AppLocalizations get l10n => _l10n;
  Locale get locale => _locale;
  bool get isRtl => _locale.languageCode == 'ar';

  void initialize(Locale locale) {
    _locale = locale;
  }

  void updateL10n(AppLocalizations l10n) {
    _l10n = l10n;
  }

  /// Format date based on locale
  String formatDate(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? 'MMM d, y', _locale.languageCode).format(date);
  }

  /// Format time based on locale
  String formatTime(DateTime time, {String? pattern}) {
    return DateFormat(pattern ?? 'h:mm a', _locale.languageCode).format(time);
  }

  /// Format currency based on locale
  String formatCurrency(double amount, {String? symbol}) {
    return NumberFormat.currency(
      locale: _locale.languageCode,
      symbol: symbol ?? _getCurrencySymbol(),
    ).format(amount);
  }

  /// Format number with locale
  String formatNumber(num number) {
    return NumberFormat.decimalPattern(_locale.languageCode).format(number);
  }

  /// Format relative time (e.g., "2 hours ago")
  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? _l10n.yearAgo : _l10n.yearsAgo}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? _l10n.monthAgo : _l10n.monthsAgo}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? _l10n.dayAgo : _l10n.daysAgo}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? _l10n.hourAgo : _l10n.hoursAgo}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? _l10n.minuteAgo : _l10n.minutesAgo}';
    } else {
      return _l10n.justNow;
    }
  }

  String _getCurrencySymbol() {
    return switch (_locale.countryCode) {
      'US' => '\$',
      'EU' => '€',
      'GB' => '£',
      'JP' => '¥',
      'IN' => '₹',
      _ => '\$',
    };
  }
}
```

---

## Locale Provider

```dart
// core/localization/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocaleProvider extends ChangeNotifier {
  static const String _key = 'app_locale';
  
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  final SharedPreferences _prefs;

  LocaleProvider(this._prefs) {
    _loadLocale();
  }

  void _loadLocale() {
    final saved = _prefs.getString(_key);
    if (saved != null) {
      _locale = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!isSupported(locale)) return;
    
    _locale = locale;
    await _prefs.setString(_key, locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = const Locale('en');
    await _prefs.remove(_key);
    notifyListeners();
  }

  bool isSupported(Locale locale) {
    return const [
      Locale('en'),
      Locale('es'),
      Locale('fr'),
      Locale('de'),
      Locale('hi'),
      Locale('ar'),
    ].contains(locale);
  }

  List<Locale> get supportedLocales => const [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('hi', 'IN'),
    Locale('ar', 'SA'),
  ];

  String getLocaleName(Locale locale) {
    return switch (locale.languageCode) {
      'en' => 'English',
      'es' => 'Español',
      'fr' => 'Français',
      'de' => 'Deutsch',
      'hi' => 'हिन्दी',
      'ar' => 'العربية',
      _ => locale.languageCode,
    };
  }
}
```

---

## Localization Extension

```dart
// core/localization/localization_extension.dart
import 'package:flutter/material.dart';

import '../../generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Quick access to localizations
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  /// Current locale
  Locale get locale => Localizations.localeOf(this);
  
  /// Check if RTL
  bool get isRtl => locale.languageCode == 'ar';
  
  /// Text direction
  TextDirection get textDirection => isRtl ? TextDirection.rtl : TextDirection.ltr;
}
```

---

## Usage Examples

### Basic String Access

```dart
// Using extension
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: Center(
        child: Text(context.l10n.welcomeMessage(name: 'John')),
      ),
    );
  }
}

// Or using AppLocalizations directly
class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Text(l10n.price(amount: 29.99)),
    );
  }
}
```

### With Parameters

```dart
column(
  children: [
    // Simple string
    Text(context.l10n.actionSave),
    
    // With variable
    Text(context.l10n.welcomeMessage(name: user.name)),
    
    // Plural
    Text(context.l10n.itemCount(count: cart.items.length)),
    
    // Select (gender)
    Text(context.l10n.genderMessage(gender: user.gender)),
  ],
)
```

### Language Selector

```dart
class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();
    
    return ListView.builder(
      itemCount: provider.supportedLocales.length,
      itemBuilder: (context, index) {
        final locale = provider.supportedLocales[index];
        final isSelected = provider.locale == locale;
        
        return ListTile(
          leading: Text(
            locale.languageCode.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          title: Text(provider.getLocaleName(locale)),
          trailing: isSelected ? const Icon(Icons.check) : null,
          onTap: () => provider.setLocale(locale),
        );
      },
    );
  }
}
```

---

## Adding New Strings (Quick Reference)

### 1. Add to app_en.arb

```json
"newStringKey": "Your string here",
"@newStringKey": {
  "description": "What this string is for"
}
```

### 2. Add with Parameters

```json
"greetingWithName": "Hello, {name}!",
"@greetingWithName": {
  "description": "Greeting with user's name",
  "placeholders": {
    "name": {
      "type": "String",
      "example": "Alice"
    }
  }
}
```

### 3. Add to Other Language Files

**app_es.arb:**
```json
"newStringKey": "Tu cadena aquí",
"greetingWithName": "¡Hola, {name}!"
```

**app_hi.arb:**
```json
"newStringKey": "आपका स्ट्रिंग यहाँ",
"greetingWithName": "नमस्ते, {name}!"
```

### 4. Generate Code

```bash
flutter gen-l10n
```

Or if configured in `l10n.yaml`, it auto-generates on hot reload.

### 5. Use in Code

```dart
text: context.l10n.newStringKey
text: context.l10n.greetingWithName(name: 'Alice')
```

---

## Common String Patterns

### Buttons & Actions

```json
{
  "actionSave": "Save",
  "actionCancel": "Cancel",
  "actionDelete": "Delete",
  "actionEdit": "Edit",
  "actionDone": "Done",
  "actionContinue": "Continue",
  "actionBack": "Back",
  "actionNext": "Next",
  "actionSubmit": "Submit",
  "actionRetry": "Retry",
  "actionClose": "Close"
}
```

### Errors

```json
{
  "errorGeneric": "Something went wrong",
  "errorNetwork": "Network connection failed",
  "errorTimeout": "Request timed out",
  "errorUnauthorized": "Session expired. Please login again.",
  "errorNotFound": "Resource not found",
  "errorValidation": "Please check your input",
  "errorServer": "Server error. Please try again later."
}
```

### Time

```json
{
  "justNow": "Just now",
  "minuteAgo": "minute ago",
  "minutesAgo": "minutes ago",
  "hourAgo": "hour ago",
  "hoursAgo": "hours ago",
  "dayAgo": "day ago",
  "daysAgo": "days ago",
  "monthAgo": "month ago",
  "monthsAgo": "months ago",
  "yearAgo": "year ago",
  "yearsAgo": "years ago"
}
```

### Validation

```json
{
  "validationRequired": "This field is required",
  "validationEmail": "Please enter a valid email",
  "validationPassword": "Password must be at least 8 characters",
  "validationMatch": "Passwords do not match",
  "validationPhone": "Please enter a valid phone number"
}
```

---

## RTL Support

```dart
// In MaterialApp
directionality: Directionality(
  textDirection: context.isRtl ? TextDirection.rtl : TextDirection.ltr,
  child: child,
),

// Or automatically handled
return MaterialApp(
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),  // RTL language
  ],
  // Flutter automatically handles RTL for Arabic
);
```

---

## Best Practices

1. **Use semantic keys** - `actionSave` not `button1`
2. **Add descriptions** - Helps translators understand context
3. **Use placeholders** - Don't concatenate strings: `"Hello, " + name`
4. **Handle plurals** - Use ICU plural format, not if/else
5. **Test with longest language** - German often longest
6. **Avoid text in images** - Hard to localize
7. **Format dates/numbers** - Use intl, don't hardcode

---

## Prohibited Patterns

❌ **Don't concatenate strings:**
```dart
// ❌ Bad
Text('Hello, ' + name + '!')

// ✅ Good
Text(context.l10n.greeting(name: name))
```

❌ **Don't hardcode plurals:**
```dart
// ❌ Bad
if (count == 1) return '1 item';
else return '$count items';

// ✅ Good
context.l10n.itemCount(count: count)
```

❌ **Don't ignore unsupported locales:**
```dart
// ❌ Bad
supportedLocales: [Locale('en')];  // Only English
```

❌ **Don't use string keys in business logic:**
```dart
// ❌ Bad
if (error == 'network_error')  // Fragile

// ✅ Good
if (error is NetworkFailure)
```

# Flutter Localization (l10n)

## Role
Manage app internationalization with ARB files, supporting multiple languages and providing utilities for easy string management.

---

## Dependencies

```bash
flutter pub add flutter_localizations intl
```

> `flutter_localizations` is an SDK package — it doesn't need a version. `intl` version is resolved automatically by pub.

---

## Setup

### l10n.yaml Configuration

```yaml
# l10n.yaml (project root)
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/generated
synthetic-package: false
output-class: AppLocalizations
nullable-getter: false
untranslated-messages-file: untranslated_messages.json
preferred-supported-locales:
  - en
```

### Main.dart Setup

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),    // English
        Locale('es'),    // Spanish
        Locale('fr'),    // French
        Locale('de'),    // German
        Locale('hi'),    // Hindi
        Locale('ar'),    // Arabic
      ],
      home: const HomePage(),
    );
  }
}
```

---

## ARB File Structure

### Base Template (app_en.arb)

```json
{
  "@@locale": "en",
  "@@last_modified": "2024-01-15T10:30:00Z",
  
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message shown on home screen",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Shows item count with proper pluralization",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },
  
  "genderMessage": "{gender, select, male{He} female{She} other{They}} liked this",
  "@genderMessage": {
    "description": "Gender-specific message",
    "placeholders": {
      "gender": {
        "type": "String"
      }
    }
  },
  
  "lastUpdated": "Last updated: {date}",
  "@lastUpdated": {
    "description": "Shows last update timestamp",
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMMd"
      }
    }
  },
  
  "price": "Price: {amount}",
  "@price": {
    "description": "Product price display",
    "placeholders": {
      "amount": {
        "type": "double",
        "format": "currency",
        "optionalParameters": {
          "symbol": "$",
          "decimalDigits": 2
        }
      }
    }
  },
  
  "actionSave": "Save",
  "@actionSave": {
    "description": "Save action button label"
  },
  
  "actionCancel": "Cancel",
  "@actionCancel": {
    "description": "Cancel action button label"
  },
  
  "actionDelete": "Delete",
  "@actionDelete": {
    "description": "Delete action button label"
  },
  
  "errorNetwork": "Network error. Please check your connection.",
  "@errorNetwork": {
    "description": "Network error message"
  },
  
  "errorUnknown": "Something went wrong. Please try again.",
  "@errorUnknown": {
    "description": "Generic error message"
  }
}
```

### Spanish Translation (app_es.arb)

```json
{
  "@@locale": "es",
  
  "appTitle": "Mi App",
  "welcomeMessage": "¡Bienvenido, {name}!",
  "itemCount": "{count, plural, =0{Sin elementos} =1{1 elemento} other{{count} elementos}}",
  "genderMessage": "{gender, select, male{Él} female{Ella} other{Ellos}} les gustó esto",
  "lastUpdated": "Última actualización: {date}",
  "price": "Precio: {amount}",
  "actionSave": "Guardar",
  "actionCancel": "Cancelar",
  "actionDelete": "Eliminar",
  "errorNetwork": "Error de red. Por favor verifica tu conexión.",
  "errorUnknown": "Algo salió mal. Por favor intenta de nuevo."
}
```

### Hindi Translation (app_hi.arb)

```json
{
  "@@locale": "hi",
  
  "appTitle": "मेरा ऐप",
  "welcomeMessage": "स्वागत है, {name}!",
  "itemCount": "{count, plural, =0{कोई आइटम नहीं} =1{1 आइटम} other{{count} आइटम}}",
  "actionSave": "सहेजें",
  "actionCancel": "रद्द करें",
  "actionDelete": "हटाएं"
}
```

---

## Localization Service

```dart
// core/localization/localization_service.dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../generated/app_localizations.dart';

@lazySingleton
class LocalizationService {
  late AppLocalizations _l10n;
  late Locale _locale;

  AppLocalizations get l10n => _l10n;
  Locale get locale => _locale;
  bool get isRtl => _locale.languageCode == 'ar';

  void initialize(Locale locale) {
    _locale = locale;
  }

  void updateL10n(AppLocalizations l10n) {
    _l10n = l10n;
  }

  /// Format date based on locale
  String formatDate(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? 'MMM d, y', _locale.languageCode).format(date);
  }

  /// Format time based on locale
  String formatTime(DateTime time, {String? pattern}) {
    return DateFormat(pattern ?? 'h:mm a', _locale.languageCode).format(time);
  }

  /// Format currency based on locale
  String formatCurrency(double amount, {String? symbol}) {
    return NumberFormat.currency(
      locale: _locale.languageCode,
      symbol: symbol ?? _getCurrencySymbol(),
    ).format(amount);
  }

  /// Format number with locale
  String formatNumber(num number) {
    return NumberFormat.decimalPattern(_locale.languageCode).format(number);
  }

  /// Format relative time (e.g., "2 hours ago")
  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? _l10n.yearAgo : _l10n.yearsAgo}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? _l10n.monthAgo : _l10n.monthsAgo}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? _l10n.dayAgo : _l10n.daysAgo}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? _l10n.hourAgo : _l10n.hoursAgo}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? _l10n.minuteAgo : _l10n.minutesAgo}';
    } else {
      return _l10n.justNow;
    }
  }

  String _getCurrencySymbol() {
    return switch (_locale.countryCode) {
      'US' => '\$',
      'EU' => '€',
      'GB' => '£',
      'JP' => '¥',
      'IN' => '₹',
      _ => '\$',
    };
  }
}
```

---

## Locale Provider

```dart
// core/localization/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocaleProvider extends ChangeNotifier {
  static const String _key = 'app_locale';
  
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  final SharedPreferences _prefs;

  LocaleProvider(this._prefs) {
    _loadLocale();
  }

  void _loadLocale() {
    final saved = _prefs.getString(_key);
    if (saved != null) {
      _locale = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!isSupported(locale)) return;
    
    _locale = locale;
    await _prefs.setString(_key, locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = const Locale('en');
    await _prefs.remove(_key);
    notifyListeners();
  }

  bool isSupported(Locale locale) {
    return const [
      Locale('en'),
      Locale('es'),
      Locale('fr'),
      Locale('de'),
      Locale('hi'),
      Locale('ar'),
    ].contains(locale);
  }

  List<Locale> get supportedLocales => const [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('hi', 'IN'),
    Locale('ar', 'SA'),
  ];

  String getLocaleName(Locale locale) {
    return switch (locale.languageCode) {
      'en' => 'English',
      'es' => 'Español',
      'fr' => 'Français',
      'de' => 'Deutsch',
      'hi' => 'हिन्दी',
      'ar' => 'العربية',
      _ => locale.languageCode,
    };
  }
}
```

---

## Localization Extension

```dart
// core/localization/localization_extension.dart
import 'package:flutter/material.dart';

import '../../generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Quick access to localizations
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  /// Current locale
  Locale get locale => Localizations.localeOf(this);
  
  /// Check if RTL
  bool get isRtl => locale.languageCode == 'ar';
  
  /// Text direction
  TextDirection get textDirection => isRtl ? TextDirection.rtl : TextDirection.ltr;
}
```

---

## Usage Examples

### Basic String Access

```dart
// Using extension
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: Center(
        child: Text(context.l10n.welcomeMessage(name: 'John')),
      ),
    );
  }
}

// Or using AppLocalizations directly
class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Text(l10n.price(amount: 29.99)),
    );
  }
}
```

### With Parameters

```dart
column(
  children: [
    // Simple string
    Text(context.l10n.actionSave),
    
    // With variable
    Text(context.l10n.welcomeMessage(name: user.name)),
    
    // Plural
    Text(context.l10n.itemCount(count: cart.items.length)),
    
    // Select (gender)
    Text(context.l10n.genderMessage(gender: user.gender)),
  ],
)
```

### Language Selector

```dart
class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();
    
    return ListView.builder(
      itemCount: provider.supportedLocales.length,
      itemBuilder: (context, index) {
        final locale = provider.supportedLocales[index];
        final isSelected = provider.locale == locale;
        
        return ListTile(
          leading: Text(
            locale.languageCode.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          title: Text(provider.getLocaleName(locale)),
          trailing: isSelected ? const Icon(Icons.check) : null,
          onTap: () => provider.setLocale(locale),
        );
      },
    );
  }
}
```

---

## Adding New Strings (Quick Reference)

### 1. Add to app_en.arb

```json
"newStringKey": "Your string here",
"@newStringKey": {
  "description": "What this string is for"
}
```

### 2. Add with Parameters

```json
"greetingWithName": "Hello, {name}!",
"@greetingWithName": {
  "description": "Greeting with user's name",
  "placeholders": {
    "name": {
      "type": "String",
      "example": "Alice"
    }
  }
}
```

### 3. Add to Other Language Files

**app_es.arb:**
```json
"newStringKey": "Tu cadena aquí",
"greetingWithName": "¡Hola, {name}!"
```

**app_hi.arb:**
```json
"newStringKey": "आपका स्ट्रिंग यहाँ",
"greetingWithName": "नमस्ते, {name}!"
```

### 4. Generate Code

```bash
flutter gen-l10n
```

Or if configured in `l10n.yaml`, it auto-generates on hot reload.

### 5. Use in Code

```dart
text: context.l10n.newStringKey
text: context.l10n.greetingWithName(name: 'Alice')
```

---

## Common String Patterns

### Buttons & Actions

```json
{
  "actionSave": "Save",
  "actionCancel": "Cancel",
  "actionDelete": "Delete",
  "actionEdit": "Edit",
  "actionDone": "Done",
  "actionContinue": "Continue",
  "actionBack": "Back",
  "actionNext": "Next",
  "actionSubmit": "Submit",
  "actionRetry": "Retry",
  "actionClose": "Close"
}
```

### Errors

```json
{
  "errorGeneric": "Something went wrong",
  "errorNetwork": "Network connection failed",
  "errorTimeout": "Request timed out",
  "errorUnauthorized": "Session expired. Please login again.",
  "errorNotFound": "Resource not found",
  "errorValidation": "Please check your input",
  "errorServer": "Server error. Please try again later."
}
```

### Time

```json
{
  "justNow": "Just now",
  "minuteAgo": "minute ago",
  "minutesAgo": "minutes ago",
  "hourAgo": "hour ago",
  "hoursAgo": "hours ago",
  "dayAgo": "day ago",
  "daysAgo": "days ago",
  "monthAgo": "month ago",
  "monthsAgo": "months ago",
  "yearAgo": "year ago",
  "yearsAgo": "years ago"
}
```

### Validation

```json
{
  "validationRequired": "This field is required",
  "validationEmail": "Please enter a valid email",
  "validationPassword": "Password must be at least 8 characters",
  "validationMatch": "Passwords do not match",
  "validationPhone": "Please enter a valid phone number"
}
```

---

## RTL Support

```dart
// In MaterialApp
directionality: Directionality(
  textDirection: context.isRtl ? TextDirection.rtl : TextDirection.ltr,
  child: child,
),

// Or automatically handled
return MaterialApp(
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),  // RTL language
  ],
  // Flutter automatically handles RTL for Arabic
);
```

---

## Best Practices

1. **Use semantic keys** - `actionSave` not `button1`
2. **Add descriptions** - Helps translators understand context
3. **Use placeholders** - Don't concatenate strings: `"Hello, " + name`
4. **Handle plurals** - Use ICU plural format, not if/else
5. **Test with longest language** - German often longest
6. **Avoid text in images** - Hard to localize
7. **Format dates/numbers** - Use intl, don't hardcode

---

## Prohibited Patterns

❌ **Don't concatenate strings:**
```dart
// ❌ Bad
Text('Hello, ' + name + '!')

// ✅ Good
Text(context.l10n.greeting(name: name))
```

❌ **Don't hardcode plurals:**
```dart
// ❌ Bad
if (count == 1) return '1 item';
else return '$count items';

// ✅ Good
context.l10n.itemCount(count: count)
```

❌ **Don't ignore unsupported locales:**
```dart
// ❌ Bad
supportedLocales: [Locale('en')];  // Only English
```

❌ **Don't use string keys in business logic:**
```dart
// ❌ Bad
if (error == 'network_error')  // Fragile

// ✅ Good
if (error is NetworkFailure)
```
