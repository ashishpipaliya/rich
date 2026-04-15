---
name: theme
description: "Implement Material 3 themes in Flutter inspired by shadcn/ui: compact density, zinc color palette, and ThemeExtension for custom colors."
---

# Flutter Material 3 Theming (shadcn/ui Style)

## Role
Implement Material 3 themes inspired by shadcn/ui aesthetics with compact, information-dense layouts.

---

## Design Philosophy

- **Dense & Compact**: Maximize content visible on screen
- **shadcn/ui Inspired**: Rounded corners (12-16px), soft shadows, muted grays
- **Material 3**: Dynamic color schemes, adaptive to platform
- **High Information Density**: Smaller padding, tighter spacing

---

## Color Scheme

### Light Theme

```dart
// core/theme/app_theme.dart
class AppTheme {
  static const Color _primary = Color(0xFF18181B);      // zinc-950
  static const Color _onPrimary = Color(0xFFFFFFFF);   // white
  static const Color _primaryContainer = Color(0xFFE4E4E7); // zinc-200
  static const Color _onPrimaryContainer = Color(0xFF18181B);
  
  static const Color _secondary = Color(0xFF71717A);     // zinc-500
  static const Color _onSecondary = Color(0xFFFFFFFF);
  
  static const Color _surface = Color(0xFFFFFFFF);         // white
  static const Color _surfaceVariant = Color(0xFFF4F4F5); // zinc-100
  static const Color _background = Color(0xFFFAFAFA);    // zinc-50
  
  static const Color _outline = Color(0xFFE4E4E7);       // zinc-200
  static const Color _outlineVariant = Color(0xFFF4F4F5); // zinc-100
  
  static const Color _error = Color(0xFFEF4444);         // red-500
  static const Color _success = Color(0xFF22C55E);       // green-500
  static const Color _warning = Color(0xFFF59E0B);       // amber-500
  
  static ColorScheme get lightColorScheme => ColorScheme(
    brightness: Brightness.light,
    primary: _primary,
    onPrimary: _onPrimary,
    primaryContainer: _primaryContainer,
    onPrimaryContainer: _onPrimaryContainer,
    secondary: _secondary,
    onSecondary: _onSecondary,
    secondaryContainer: _primaryContainer,
    onSecondaryContainer: _onPrimaryContainer,
    surface: _surface,
    onSurface: _primary,
    surfaceContainerHighest: _surfaceVariant,
    onSurfaceVariant: _secondary,
    outline: _outline,
    outlineVariant: _outlineVariant,
    error: _error,
    onError: Colors.white,
    errorContainer: _error.withValues(alpha: 0.1),
    onErrorContainer: _error,
  );
}
```

### Dark Theme

```dart
static const Color _darkPrimary = Color(0xFFFFFFFF);       // white
static const Color _darkOnPrimary = Color(0xFF18181B);     // zinc-950
static const Color _darkPrimaryContainer = Color(0xFF27272A); // zinc-800
static const Color _darkOnPrimaryContainer = Color(0xFFFFFFFF);

static const Color _darkSurface = Color(0xFF09090B);       // zinc-950
static const Color _darkSurfaceVariant = Color(0xFF18181B); // zinc-900
static const Color _darkBackground = Color(0xFF09090B);    // zinc-950

static const Color _darkOutline = Color(0xFF27272A);       // zinc-800

static ColorScheme get darkColorScheme => ColorScheme(
  brightness: Brightness.dark,
  primary: _darkPrimary,
  onPrimary: _darkOnPrimary,
  primaryContainer: _darkPrimaryContainer,
  onPrimaryContainer: _darkOnPrimaryContainer,
  secondary: Color(0xFFA1A1AA), // zinc-400
  onSecondary: _darkOnPrimary,
  secondaryContainer: _darkPrimaryContainer,
  onSecondaryContainer: _darkPrimary,
  surface: _darkSurface,
  onSurface: _darkPrimary,
  surfaceContainerHighest: _darkSurfaceVariant,
  onSurfaceVariant: Color(0xFFA1A1AA),
  outline: _darkOutline,
  outlineVariant: _darkPrimaryContainer,
  error: Color(0xFFFCA5A5), // red-300
  onError: _darkBackground,
  errorContainer: Color(0xFF7F1D1D),
  onErrorContainer: Color(0xFFFCA5A5),
);
```

---

## Theme Configuration

```dart
// core/theme/app_theme.dart
class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    brightness: Brightness.light,
    
    // Typography - compact
    textTheme: _textTheme,
    
    // Components
    appBarTheme: _appBarTheme,
    cardTheme: _cardTheme,
    inputDecorationTheme: _inputDecorationTheme,
    buttonTheme: _buttonTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    chipTheme: _chipTheme,
    listTileTheme: _listTileTheme,
    dividerTheme: _dividerTheme,
    
    // Compact density
    visualDensity: VisualDensity.compact,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    brightness: Brightness.dark,
    textTheme: _textTheme,
    appBarTheme: _darkAppBarTheme,
    cardTheme: _darkCardTheme,
    inputDecorationTheme: _inputDecorationTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    chipTheme: _darkChipTheme,
    listTileTheme: _listTileTheme,
    dividerTheme: _dividerTheme,
    visualDensity: VisualDensity.compact,
  );
}
```

---

## Typography (Compact)

```dart
static const TextTheme _textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  ),
  displayMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  ),
  displaySmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  ),
  headlineLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  ),
  headlineMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  ),
  headlineSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  ),
  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  ),
  titleMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  ),
  titleSmall: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
  ),
  bodyLarge: TextStyle(
    fontSize: 14,
    height: 1.5,
  ),
  bodyMedium: TextStyle(
    fontSize: 13,
    height: 1.5,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    height: 1.5,
  ),
  labelLarge: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
  labelMedium: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
);
```

---

## Component Themes

### AppBar (Compact)

```dart
static AppBarTheme get _appBarTheme => AppBarTheme(
  centerTitle: false,
  elevation: 0,
  scrolledUnderElevation: 0.5,
  backgroundColor: Colors.white,
  foregroundColor: _primary,
  titleTextStyle: _textTheme.titleLarge?.copyWith(
    color: _primary,
    fontWeight: FontWeight.w600,
  ),
  toolbarHeight: 48, // Compact height
  iconTheme: const IconThemeData(size: 20),
  actionsIconTheme: const IconThemeData(size: 20),
);

static AppBarTheme get _darkAppBarTheme => AppBarTheme(
  centerTitle: false,
  elevation: 0,
  scrolledUnderElevation: 0.5,
  backgroundColor: _darkSurface,
  foregroundColor: _darkPrimary,
  titleTextStyle: _textTheme.titleLarge?.copyWith(
    color: _darkPrimary,
    fontWeight: FontWeight.w600,
  ),
  toolbarHeight: 48,
);
```

### Card (shadcn style)

```dart
static CardTheme get _cardTheme => CardTheme(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(color: _outline),
  ),
  color: _surface,
  clipBehavior: Clip.antiAlias,
);

static CardTheme get _darkCardTheme => CardTheme(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(color: _darkOutline),
  ),
  color: _darkSurface,
);
```

### Input (Compact)

```dart
static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
  filled: true,
  fillColor: _surfaceVariant,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _outline),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _outline),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _primary, width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _error),
  ),
  labelStyle: _textTheme.bodyMedium,
  hintStyle: _textTheme.bodyMedium?.copyWith(
    color: _secondary,
  ),
  isDense: true,
);
```

### Buttons (Compact)

```dart
static ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    minimumSize: const Size(0, 36),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: _textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
    ),
  ),
);

static OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    minimumSize: const Size(0, 36),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: const BorderSide(color: _outline),
    textStyle: _textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
    ),
  ),
);

static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    minimumSize: const Size(0, 32),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    textStyle: _textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
    ),
  ),
);
```

### Chips (Compact)

```dart
static ChipThemeData get _chipTheme => ChipThemeData(
  backgroundColor: _surfaceVariant,
  selectedColor: _primaryContainer,
  labelStyle: _textTheme.labelMedium,
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
  ),
  side: BorderSide.none,
);

static ChipThemeData get _darkChipTheme => ChipThemeData(
  backgroundColor: _darkPrimaryContainer,
  selectedColor: _darkPrimaryContainer,
  labelStyle: _textTheme.labelMedium?.copyWith(color: _darkPrimary),
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
  ),
  side: BorderSide.none,
);
```

### ListTile (Compact)

```dart
static ListTileThemeData get _listTileTheme => ListTileThemeData(
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  minVerticalPadding: 8,
  horizontalTitleGap: 12,
  minLeadingWidth: 24,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  titleTextStyle: _textTheme.bodyMedium?.copyWith(
    fontWeight: FontWeight.w500,
  ),
  subtitleTextStyle: _textTheme.bodySmall?.copyWith(
    color: _secondary,
  ),
  dense: true,
  visualDensity: VisualDensity.compact,
);
```

### Divider

```dart
static DividerThemeData get _dividerTheme => DividerThemeData(
  color: _outline,
  thickness: 1,
  space: 1,
  indent: 0,
  endIndent: 0,
);
```

---

## Compact Spacing

```dart
class AppSpacing {
  // Even tighter spacing for dense layouts
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  
  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(12);
  static const EdgeInsets cardPaddingDense = EdgeInsets.all(8);
  
  // List spacing
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );
  
  // Page padding
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
}
```

---

## Custom Components

### AppCard (Dense)

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? color;

  const AppCard({
    required this.child,
    this.onTap,
    this.padding = AppSpacing.cardPadding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Card(
      color: color,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }
    return card;
  }
}
```

### AppBadge

```dart
class AppBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final AppBadgeVariant variant;

  const AppBadge({
    required this.label,
    this.variant = AppBadgeVariant.default_,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getColors(theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

enum AppBadgeVariant { default_, secondary, outline, destructive }
```

### AppTable (Dense Data Display)

```dart
class AppDataTable<T> extends StatelessWidget {
  final List<T> data;
  final List<DataColumn> columns;
  final DataRow Function(T) rowBuilder;
  final VoidCallback? onRowTap;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowMinHeight: 40,
      dataRowMaxHeight: 48,
      headingRowHeight: 40,
      horizontalMargin: 12,
      columnSpacing: 16,
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
      columns: columns,
      rows: data.map(rowBuilder).toList(),
    );
  }
}
```

---

## Usage

```dart
// main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
```

### Responsive Theme

```dart
// Handle theme changes
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }
}
```

---

## Key Characteristics

| Aspect | Value | Purpose |
|--------|-------|---------|
| Border Radius | 8-12px | shadcn/ui aesthetic |
| Card Padding | 12px | Dense but readable |
| List Item Height | 40-48px | Fit more items |
| Typography Scale | 10-32px | Compact hierarchy |
| Line Height | 1.2-1.5 | Tight but legible |
| Letter Spacing | -0.5 to 0.5 | Modern feel |
| Visual Density | compact | Maximum content |

# Flutter Material 3 Theming (shadcn/ui Style)

## Role
Implement Material 3 themes inspired by shadcn/ui aesthetics with compact, information-dense layouts.

---

## Design Philosophy

- **Dense & Compact**: Maximize content visible on screen
- **shadcn/ui Inspired**: Rounded corners (12-16px), soft shadows, muted grays
- **Material 3**: Dynamic color schemes, adaptive to platform
- **High Information Density**: Smaller padding, tighter spacing

---

## Color Scheme

### Light Theme

```dart
// core/theme/app_theme.dart
class AppTheme {
  static const Color _primary = Color(0xFF18181B);      // zinc-950
  static const Color _onPrimary = Color(0xFFFFFFFF);   // white
  static const Color _primaryContainer = Color(0xFFE4E4E7); // zinc-200
  static const Color _onPrimaryContainer = Color(0xFF18181B);
  
  static const Color _secondary = Color(0xFF71717A);     // zinc-500
  static const Color _onSecondary = Color(0xFFFFFFFF);
  
  static const Color _surface = Color(0xFFFFFFFF);         // white
  static const Color _surfaceVariant = Color(0xFFF4F4F5); // zinc-100
  static const Color _background = Color(0xFFFAFAFA);    // zinc-50
  
  static const Color _outline = Color(0xFFE4E4E7);       // zinc-200
  static const Color _outlineVariant = Color(0xFFF4F4F5); // zinc-100
  
  static const Color _error = Color(0xFFEF4444);         // red-500
  static const Color _success = Color(0xFF22C55E);       // green-500
  static const Color _warning = Color(0xFFF59E0B);       // amber-500
  
  static ColorScheme get lightColorScheme => ColorScheme(
    brightness: Brightness.light,
    primary: _primary,
    onPrimary: _onPrimary,
    primaryContainer: _primaryContainer,
    onPrimaryContainer: _onPrimaryContainer,
    secondary: _secondary,
    onSecondary: _onSecondary,
    secondaryContainer: _primaryContainer,
    onSecondaryContainer: _onPrimaryContainer,
    surface: _surface,
    onSurface: _primary,
    surfaceContainerHighest: _surfaceVariant,
    onSurfaceVariant: _secondary,
    outline: _outline,
    outlineVariant: _outlineVariant,
    error: _error,
    onError: Colors.white,
    errorContainer: _error.withValues(alpha: 0.1),
    onErrorContainer: _error,
  );
}
```

### Dark Theme

```dart
static const Color _darkPrimary = Color(0xFFFFFFFF);       // white
static const Color _darkOnPrimary = Color(0xFF18181B);     // zinc-950
static const Color _darkPrimaryContainer = Color(0xFF27272A); // zinc-800
static const Color _darkOnPrimaryContainer = Color(0xFFFFFFFF);

static const Color _darkSurface = Color(0xFF09090B);       // zinc-950
static const Color _darkSurfaceVariant = Color(0xFF18181B); // zinc-900
static const Color _darkBackground = Color(0xFF09090B);    // zinc-950

static const Color _darkOutline = Color(0xFF27272A);       // zinc-800

static ColorScheme get darkColorScheme => ColorScheme(
  brightness: Brightness.dark,
  primary: _darkPrimary,
  onPrimary: _darkOnPrimary,
  primaryContainer: _darkPrimaryContainer,
  onPrimaryContainer: _darkOnPrimaryContainer,
  secondary: Color(0xFFA1A1AA), // zinc-400
  onSecondary: _darkOnPrimary,
  secondaryContainer: _darkPrimaryContainer,
  onSecondaryContainer: _darkPrimary,
  surface: _darkSurface,
  onSurface: _darkPrimary,
  surfaceContainerHighest: _darkSurfaceVariant,
  onSurfaceVariant: Color(0xFFA1A1AA),
  outline: _darkOutline,
  outlineVariant: _darkPrimaryContainer,
  error: Color(0xFFFCA5A5), // red-300
  onError: _darkBackground,
  errorContainer: Color(0xFF7F1D1D),
  onErrorContainer: Color(0xFFFCA5A5),
);
```

---

## Theme Configuration

```dart
// core/theme/app_theme.dart
class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    brightness: Brightness.light,
    
    // Typography - compact
    textTheme: _textTheme,
    
    // Components
    appBarTheme: _appBarTheme,
    cardTheme: _cardTheme,
    inputDecorationTheme: _inputDecorationTheme,
    buttonTheme: _buttonTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    chipTheme: _chipTheme,
    listTileTheme: _listTileTheme,
    dividerTheme: _dividerTheme,
    
    // Compact density
    visualDensity: VisualDensity.compact,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    brightness: Brightness.dark,
    textTheme: _textTheme,
    appBarTheme: _darkAppBarTheme,
    cardTheme: _darkCardTheme,
    inputDecorationTheme: _inputDecorationTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    chipTheme: _darkChipTheme,
    listTileTheme: _listTileTheme,
    dividerTheme: _dividerTheme,
    visualDensity: VisualDensity.compact,
  );
}
```

---

## Typography (Compact)

```dart
static const TextTheme _textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  ),
  displayMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  ),
  displaySmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  ),
  headlineLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  ),
  headlineMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  ),
  headlineSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  ),
  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  ),
  titleMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  ),
  titleSmall: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
  ),
  bodyLarge: TextStyle(
    fontSize: 14,
    height: 1.5,
  ),
  bodyMedium: TextStyle(
    fontSize: 13,
    height: 1.5,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    height: 1.5,
  ),
  labelLarge: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
  labelMedium: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
);
```

---

## Component Themes

### AppBar (Compact)

```dart
static AppBarTheme get _appBarTheme => AppBarTheme(
  centerTitle: false,
  elevation: 0,
  scrolledUnderElevation: 0.5,
  backgroundColor: Colors.white,
  foregroundColor: _primary,
  titleTextStyle: _textTheme.titleLarge?.copyWith(
    color: _primary,
    fontWeight: FontWeight.w600,
  ),
  toolbarHeight: 48, // Compact height
  iconTheme: const IconThemeData(size: 20),
  actionsIconTheme: const IconThemeData(size: 20),
);

static AppBarTheme get _darkAppBarTheme => AppBarTheme(
  centerTitle: false,
  elevation: 0,
  scrolledUnderElevation: 0.5,
  backgroundColor: _darkSurface,
  foregroundColor: _darkPrimary,
  titleTextStyle: _textTheme.titleLarge?.copyWith(
    color: _darkPrimary,
    fontWeight: FontWeight.w600,
  ),
  toolbarHeight: 48,
);
```

### Card (shadcn style)

```dart
static CardTheme get _cardTheme => CardTheme(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(color: _outline),
  ),
  color: _surface,
  clipBehavior: Clip.antiAlias,
);

static CardTheme get _darkCardTheme => CardTheme(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(color: _darkOutline),
  ),
  color: _darkSurface,
);
```

### Input (Compact)

```dart
static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
  filled: true,
  fillColor: _surfaceVariant,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _outline),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _outline),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _primary, width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _error),
  ),
  labelStyle: _textTheme.bodyMedium,
  hintStyle: _textTheme.bodyMedium?.copyWith(
    color: _secondary,
  ),
  isDense: true,
);
```

### Buttons (Compact)

```dart
static ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    minimumSize: const Size(0, 36),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: _textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
    ),
  ),
);

static OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    minimumSize: const Size(0, 36),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: const BorderSide(color: _outline),
    textStyle: _textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
    ),
  ),
);

static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    minimumSize: const Size(0, 32),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    textStyle: _textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
    ),
  ),
);
```

### Chips (Compact)

```dart
static ChipThemeData get _chipTheme => ChipThemeData(
  backgroundColor: _surfaceVariant,
  selectedColor: _primaryContainer,
  labelStyle: _textTheme.labelMedium,
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
  ),
  side: BorderSide.none,
);

static ChipThemeData get _darkChipTheme => ChipThemeData(
  backgroundColor: _darkPrimaryContainer,
  selectedColor: _darkPrimaryContainer,
  labelStyle: _textTheme.labelMedium?.copyWith(color: _darkPrimary),
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
  ),
  side: BorderSide.none,
);
```

### ListTile (Compact)

```dart
static ListTileThemeData get _listTileTheme => ListTileThemeData(
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  minVerticalPadding: 8,
  horizontalTitleGap: 12,
  minLeadingWidth: 24,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  titleTextStyle: _textTheme.bodyMedium?.copyWith(
    fontWeight: FontWeight.w500,
  ),
  subtitleTextStyle: _textTheme.bodySmall?.copyWith(
    color: _secondary,
  ),
  dense: true,
  visualDensity: VisualDensity.compact,
);
```

### Divider

```dart
static DividerThemeData get _dividerTheme => DividerThemeData(
  color: _outline,
  thickness: 1,
  space: 1,
  indent: 0,
  endIndent: 0,
);
```

---

## Compact Spacing

```dart
class AppSpacing {
  // Even tighter spacing for dense layouts
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  
  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(12);
  static const EdgeInsets cardPaddingDense = EdgeInsets.all(8);
  
  // List spacing
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );
  
  // Page padding
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
}
```

---

## Custom Components

### AppCard (Dense)

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? color;

  const AppCard({
    required this.child,
    this.onTap,
    this.padding = AppSpacing.cardPadding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Card(
      color: color,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }
    return card;
  }
}
```

### AppBadge

```dart
class AppBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final AppBadgeVariant variant;

  const AppBadge({
    required this.label,
    this.variant = AppBadgeVariant.default_,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getColors(theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

enum AppBadgeVariant { default_, secondary, outline, destructive }
```

### AppTable (Dense Data Display)

```dart
class AppDataTable<T> extends StatelessWidget {
  final List<T> data;
  final List<DataColumn> columns;
  final DataRow Function(T) rowBuilder;
  final VoidCallback? onRowTap;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowMinHeight: 40,
      dataRowMaxHeight: 48,
      headingRowHeight: 40,
      horizontalMargin: 12,
      columnSpacing: 16,
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
      columns: columns,
      rows: data.map(rowBuilder).toList(),
    );
  }
}
```

---

## Usage

```dart
// main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
```

### Responsive Theme

```dart
// Handle theme changes
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }
}
```

---

## Key Characteristics

| Aspect | Value | Purpose |
|--------|-------|---------|
| Border Radius | 8-12px | shadcn/ui aesthetic |
| Card Padding | 12px | Dense but readable |
| List Item Height | 40-48px | Fit more items |
| Typography Scale | 10-32px | Compact hierarchy |
| Line Height | 1.2-1.5 | Tight but legible |
| Letter Spacing | -0.5 to 0.5 | Modern feel |
| Visual Density | compact | Maximum content |
