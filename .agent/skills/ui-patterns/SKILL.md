---
name: ui-patterns
description: "Implement Flutter UI components following best practices: const constructors, isolated rebuilds, ListView.builder, RepaintBoundary, and skeleton loading."
---

# Flutter UI/Widget Patterns

## Role
Implement UI components following best practices for performance, maintainability, and consistency.

---

## Widget Organization

### Widget Types

```
lib/
  core/
    widgets/                     # Global reusable widgets
      app_button.dart
      app_card.dart
      app_text_field.dart
      app_empty_state.dart
      app_loading.dart
      
  features/
    feature_name/
      presentation/
        pages/                   # Screen widgets
          home_page.dart
        widgets/                 # Feature-specific widgets
          user_profile_card.dart
          settings_list_tile.dart
```

### Widget Classification

| Type | Purpose | Example |
|------|---------|---------|
| **Atom** | Smallest UI element | `AppButton`, `AppChip` |
| **Molecule** | Group of atoms | `AppTextField` (label + input + error) |
| **Organism** | Complex component | `UserProfileCard` |
| **Template** | Page layout | `DashboardLayout` |
| **Page** | Full screen | `HomePage` |

---

## Core Widgets

### AppButton

```dart
// core/widgets/app_button.dart
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;

  const AppButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _getStyle(context),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}
```

### AppTextField

```dart
// core/widgets/app_text_field.dart
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    this.label,
    this.hint,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
```

### AppEmptyState

```dart
// core/widgets/app_empty_state.dart
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  factory AppEmptyState.error({String? message}) => AppEmptyState(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        subtitle: message,
      );

  factory AppEmptyState.empty({String? message}) => AppEmptyState(
        icon: Icons.inbox,
        title: 'No items found',
        subtitle: message,
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            AppButton(label: actionLabel!, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
```

---

## Widget Design Patterns

### 1. const Constructors

```dart
// ✅ Good - enables widget caching
class StaticWidget extends StatelessWidget {
  const StaticWidget();  // const constructor
  
  @override
  Widget build(BuildContext context) {
    return const Text('Never changes');
  }
}

// Usage
const StaticWidget();  // Efficient - doesn't rebuild
StaticWidget();      // Less efficient - rebuilds
```

### 2. Builder Methods

```dart
// ❌ Bad - rebuilds entire widget
class BadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(),
        BlocBuilder<Bloc, State>(
          builder: (context, state) => Body(state: state),
        ),
        Footer(),  // Rebuilds even when state changes
      ],
    );
  }
}

// ✅ Good - isolates rebuilds
class GoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(),  // Never rebuilds
        _buildBody(),     // Only this rebuilds
        const Footer(),   // Never rebuilds
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<Bloc, State>(
      builder: (context, state) => Body(state: state),
    );
  }
}
```

### 3. const Lists

```dart
// ❌ Bad - creates new list every build
Column(
  children: [
    Widget1(),
    Widget2(),
  ],
)

// ✅ Good - const list, const children
const Column(
  children: [
    Widget1(),
    Widget2(),
  ],
)
```

### 4. Keys for Stateful Widgets

```dart
// ✅ Good - preserves state across rebuilds
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    key: ValueKey(items[index].id),  // Unique key
    title: Text(items[index].title),
  ),
)
```

---

## Performance Patterns

### ListView.builder for Long Lists

```dart
// ❌ Bad - builds all items at once
Column(
  children: items.map((item) => ListTile(...)).toList(),
)

// ✅ Good - lazy builds items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index].title),
  ),
)

// ✅ Good - with item extent for performance
ListView.builder(
  itemCount: items.length,
  itemExtent: 72,  // Helps with scrolling performance
  itemBuilder: (context, index) => ListTile(...),
)
```

### RepaintBoundary

```dart
// ✅ Good - isolates expensive repaints
RepaintBoundary(
  child: ComplexChart(data: data),
)
```

### Image Caching

```dart
// ✅ Good - caches network images
CachedNetworkImage(
  imageUrl: user.avatarUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

---

## State Handling

### Loading States

```dart
BlocBuilder<FeatureBloc, FeatureState>(
  builder: (context, state) => state.when(
    initial: () => const SizedBox.shrink(),
    loading: () => const AppLoading(),
    success: (data) => DataWidget(data: data),
    failure: (error) => AppEmptyState.error(message: error),
  ),
)
```

### Skeleton Loading

```dart
class SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
```

---

## Responsive Design

### LayoutBuilder

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else if (constraints.maxWidth < 1200) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### OrientationBuilder

```dart
OrientationBuilder(
  builder: (context, orientation) {
    return orientation == Orientation.portrait
        ? PortraitLayout()
        : LandscapeLayout();
  },
)
```

---

## Animation Patterns

### FadeTransition

```dart
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: isLoading
      ? const CircularProgressIndicator()
      : const Icon(Icons.check),
)
```

### Hero Animations

```dart
// Page 1
Hero(
  tag: 'product-${product.id}',
  child: Image.network(product.imageUrl),
)

// Page 2
Hero(
  tag: 'product-${product.id}',  // Same tag
  child: Image.network(product.imageUrl),
)
```

---

## Best Practices

1. **Use const widgets** - Improves performance
2. **Keep widgets small** - Single responsibility
3. **Use const constructors** - Enables widget caching
4. **Use builder methods** - Isolate rebuilds
5. **Add keys when needed** - For stateful lists
6. **Use ListView.builder** - For long lists
7. **Cache images** - Use cached_network_image
8. **Handle loading/error states** - Always

---

## Prohibited Patterns

❌ **Don't use setState in large widgets:**
```dart
// ❌ Bad
class BadWidget extends StatefulWidget {
  @override
  State createState() => _BadWidgetState();
}

class _BadWidgetState extends State<BadWidget> {
  String text = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ComplexWidget1(),
          TextField(
            onChanged: (value) => setState(() => text = value),  // Rebuilds everything
          ),
          ComplexWidget2(),
        ],
      ),
    );
  }
}

// ✅ Good - use BLoC or split widgets
```

❌ **Don't pass BuildContext to BLoCs:**
```dart
// ❌ Bad
class MyBloc extends Bloc {
  void navigate(BuildContext context) {  // Don't do this
    Navigator.of(context).push(...);
  }
}
```

❌ **Don't use dynamic types:**
```dart
// ❌ Bad
Widget build(BuildContext context) {
  final data = fetchData();  // dynamic
  return Text(data.title);   // Runtime error possible
}

// ✅ Good
final UserData data = fetchData();
```

❌ **Don't ignore widget lifecycle:**
```dart
// ❌ Bad
class BadWidget extends StatefulWidget {
  final controller = TextEditingController();  // Not disposed
  
  @override
  Widget build(BuildContext context) => TextField(controller: controller);
}

// ✅ Good
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```
