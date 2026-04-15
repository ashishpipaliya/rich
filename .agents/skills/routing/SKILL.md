---
name: routing
description: "Implement Flutter navigation using GoRouter with deep linking, auth guards, nested routes, and back-navigation handling."
---

# Flutter Routing with GoRouter

## Role
Implement navigation using GoRouter with deep linking, guards, and nested routes.

---

## Setup

### Basic Configuration

```dart
// core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/presentation/view/login_page.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../features/splash/presentation/view/splash_page.dart';
import '../di/injection.dart';

final appRouter = GoRouter(
  initialLocation: SplashPage.routeName,
  
  // Authentication guard
  redirect: (context, state) async {
    final isOnSplash = state.matchedLocation == SplashPage.routeName;
    if (isOnSplash) return null;
    
    final isAuthenticated = await getIt<AuthRepository>().isAuthenticated();
    final isOnLogin = state.matchedLocation == LoginPage.routeName;
    
    if (!isAuthenticated && !isOnLogin) return LoginPage.routeName;
    if (isAuthenticated && isOnLogin) return HomePage.routeName;
    return null;
  },
  
  routes: [
    GoRoute(
      path: SplashPage.routeName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
```

### With Navigator Key (for dialogs/snackbars from BLoCs)

```dart
// core/navigation/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  BuildContext? get context => navigatorKey.currentContext;
  
  void showSnackbar(String message) {
    if (context == null) return;
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// router configuration
final appRouter = GoRouter(
  navigatorKey: getIt<NavigationService>().navigatorKey,
  routes: [ /* ... */ ],
);
```

---

## Route Patterns

### Route Constants

```dart
// In each page
class LoginPage extends StatelessWidget {
  static const String routeName = '/login';
  
  @override
  Widget build(BuildContext context) { }
}

class HomePage extends StatelessWidget {
  static const String routeName = '/';
}
```

### Deep Linking with Parameters

```dart
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return ProductPage(productId: id);
  },
),

GoRoute(
  path: '/user/:userId/profile',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return ProfilePage(userId: userId);
  },
),
```

### Query Parameters

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final category = state.uri.queryParameters['category'];
    return SearchPage(query: query, category: category);
  },
),

// Usage: /search?q=flutter&category=tech
```

### Optional Parameters

```dart
GoRoute(
  path: '/product/:id?',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    if (id == null) return const ProductListPage();
    return ProductPage(productId: int.parse(id));
  },
),
```

---

## Nested Routes

```dart
GoRoute(
  path: '/dashboard',
  builder: (context, state) => const DashboardShell(),
  routes: [
    GoRoute(
      path: 'stats',
      builder: (context, state) => const StatsPage(),
    ),
    GoRoute(
      path: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: 'profile/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProfilePage(id: id);
      },
    ),
  ],
),

// Routes:
// /dashboard
// /dashboard/stats
// /dashboard/settings
// /dashboard/profile/123
```

---

## Navigation Patterns

### Programmatic Navigation

```dart
// Navigate to route
context.go('/home');
context.go(HomePage.routeName);

// Navigate with parameters
context.go('/product/${product.id}');

// Navigate with query params
context.go('/search?q=$query&category=$category');

// Push (add to stack)
context.push('/details');

// Replace current route
context.replace('/new-route');

// Go back
context.pop();
```

### Navigation from BLoC

```dart
// ❌ Don't use context in BLoC
// ✅ Use NavigationService or callback

// Option 1: Callback pattern
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.when(
      success: (_) => context.go(HomePage.routeName),
      failure: (msg) => showErrorSnackbar(context, msg),
      orElse: () {},
    );
  },
  child: /* ... */,
)

// Option 2: NavigationService (for non-UI triggered navigation)
@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final NavigationService _navigation;
  
  void _onSuccess() {
    _navigation.showSnackbar('Payment successful');
  }
}
```

---

## Route Guards

### Authentication Guard

```dart
redirect: (context, state) async {
  final authRepository = getIt<AuthRepository>();
  final isAuthenticated = await authRepository.isAuthenticated();
  final location = state.matchedLocation;
  
  // Public routes that don't require auth
  final publicRoutes = ['/login', '/register', '/forgot-password'];
  final isPublicRoute = publicRoutes.contains(location);
  
  if (!isAuthenticated && !isPublicRoute) {
    return '/login?redirect=${Uri.encodeComponent(location)}';
  }
  
  if (isAuthenticated && location == '/login') {
    return '/';
  }
  
  return null; // No redirect
},
```

### Role-Based Guard

```dart
redirect: (context, state) async {
  final userRepository = getIt<UserRepository>();
  final user = await userRepository.getCurrentUser();
  final location = state.matchedLocation;
  
  // Admin-only routes
  if (location.startsWith('/admin') && user.role != 'admin') {
    return '/unauthorized';
  }
  
  return null;
},
```

---

## Error Handling

### 404 Page

```dart
errorBuilder: (context, state) {
  return Scaffold(
    body: AppEmptyState.error(
      message: 'Page not found: ${state.uri}',
    ),
  );
},
```

### Deep Link Validation

```dart
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final idStr = state.pathParameters['id'];
    final id = int.tryParse(idStr ?? '');
    
    if (id == null) {
      return const InvalidProductPage();
    }
    
    return ProductPage(productId: id);
  },
),
```

---

## UI Integration

### MaterialApp.router

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      routerConfig: appRouter,
      // ... other config
    );
  }
}
```

### Bottom Navigation with ShellRoute

```dart
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExplorePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
  
  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }
  
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/');
      case 1: context.go('/explore');
      case 2: context.go('/profile');
    }
  }
}
```

---

## Deep Link Back Navigation

### The Problem

When navigating via `context.go()` from a deep link or FCM notification, pressing back exits the app because there's no navigation history.

```dart
// ❌ Problem: Back button exits app
context.go('/product/123');  // No history, back = exit
```

### Solutions

#### Option 1: Push Instead of Go (Recommended for Modal Flows)

Use `push()` when you want users to return to the previous screen:

```dart
// ✅ Better: User can go back to previous screen
context.push('/product/123');

// Or with parameters
context.push('/order/${order.id}');
```

#### Option 2: Ensure Home Route in Stack

Use `go()` with a stack that includes home route:

```dart
// Navigate but keep home route in stack
context.go('/');  // First go home
context.push('/product/123');  // Then push target
```

#### Option 3: Shell Route with Bottom Nav

For deep links into tabbed navigation, use `go()` with the correct tab:

```dart
// Navigate to specific tab with deep link
context.go('/explore/product/123');

// ShellRoute handles keeping other tabs in memory
```

#### Option 4: Custom Back Navigation Handler

In your page, handle back button to navigate home instead of exit:

```dart
class ProductPage extends StatelessWidget {
  final int productId;
  
  const ProductPage({required this.productId});
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If no history, go home instead of exit
        if (!context.canPop()) {
          context.go(HomePage.routeName);
          return false;  // Don't pop (we navigated instead)
        }
        return true;  // Allow normal pop
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: /* ... */,
      ),
    );
  }
}
```

#### Option 5: GoRouter Redirect with History Check

Check if coming from deep link and redirect to stack:

```dart
final appRouter = GoRouter(
  redirect: (context, state) {
    final isDeepLink = state.extra?['fromDeepLink'] == true;
    final isTargetRoute = state.matchedLocation.startsWith('/product');
    
    // If deep link to product and no history, go to home first
    if (isDeepLink && isTargetRoute && !context.canPop()) {
      return '/?then=${Uri.encodeComponent(state.matchedLocation)}';
    }
    return null;
  },
  routes: [ /* ... */ ],
);
```

### Recommended Pattern for FCM + Deep Links

```dart
void _handleNavigation(RemoteMessage message) {
  final data = message.data;
  final route = data['route'];
  final params = data['params'];
  final allowBack = data['allow_back'] != 'false';  // Default true
  
  final context = getIt<GoRouter>().routerDelegate.navigatorKey.currentContext;
  if (context == null) return;
  
  switch (route) {
    case 'product':
      final id = params['id']?.toString();
      if (id == null) return;
      
      if (allowBack) {
        // Push so user can go back
        context.push('/product/$id');
      } else {
        // Replace entire stack (e.g., from notification)
        context.go('/product/$id');
      }
      break;
      
    case 'order':
      // Always push orders - user might want to go back
      context.push('/orders/${params['id']}');
      break;
      
    case 'promotion':
      // Go to promotions (single screen, no back needed)
      context.go('/promotions');
      break;
  }
}
```

### Server Payload with Navigation Hint

```json
{
  "notification": {
    "title": "New Message",
    "body": "You have a new message"
  },
  "data": {
    "route": "chat",
    "params": "{\"id\": 123}",
    "allow_back": "true",
    "fallback_route": "/messages"
  }
}
```

---

## Best Practices

1. **Use static route constants** - Avoid magic strings
2. **Centralize router config** - Single source of truth
3. **Use redirect for guards** - Clean separation of concerns
4. **Parse params safely** - Handle invalid deep links
5. **Don't use context in BLoCs** - Use callbacks or NavigationService
6. **Test deep links** - Verify all URL patterns work

---

## Prohibited Patterns

❌ **Don't use Navigator directly:**
```dart
// WRONG
Navigator.of(context).push(MaterialPageRoute(...));

// CORRECT
context.go('/route');
```

❌ **Don't hardcode route strings:**
```dart
// WRONG
context.go('/home');

// CORRECT
context.go(HomePage.routeName);
```

❌ **Don't use context in BLoCs:**
```dart
// WRONG
class MyBloc extends Bloc {
  void navigate() => context.go('/home');
}
```

# Flutter Routing with GoRouter

## Role
Implement navigation using GoRouter with deep linking, guards, and nested routes.

---

## Setup

### Basic Configuration

```dart
// core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/presentation/view/login_page.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../features/splash/presentation/view/splash_page.dart';
import '../di/injection.dart';

final appRouter = GoRouter(
  initialLocation: SplashPage.routeName,
  
  // Authentication guard
  redirect: (context, state) async {
    final isOnSplash = state.matchedLocation == SplashPage.routeName;
    if (isOnSplash) return null;
    
    final isAuthenticated = await getIt<AuthRepository>().isAuthenticated();
    final isOnLogin = state.matchedLocation == LoginPage.routeName;
    
    if (!isAuthenticated && !isOnLogin) return LoginPage.routeName;
    if (isAuthenticated && isOnLogin) return HomePage.routeName;
    return null;
  },
  
  routes: [
    GoRoute(
      path: SplashPage.routeName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
```

### With Navigator Key (for dialogs/snackbars from BLoCs)

```dart
// core/navigation/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  BuildContext? get context => navigatorKey.currentContext;
  
  void showSnackbar(String message) {
    if (context == null) return;
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// router configuration
final appRouter = GoRouter(
  navigatorKey: getIt<NavigationService>().navigatorKey,
  routes: [ /* ... */ ],
);
```

---

## Route Patterns

### Route Constants

```dart
// In each page
class LoginPage extends StatelessWidget {
  static const String routeName = '/login';
  
  @override
  Widget build(BuildContext context) { }
}

class HomePage extends StatelessWidget {
  static const String routeName = '/';
}
```

### Deep Linking with Parameters

```dart
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return ProductPage(productId: id);
  },
),

GoRoute(
  path: '/user/:userId/profile',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return ProfilePage(userId: userId);
  },
),
```

### Query Parameters

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final category = state.uri.queryParameters['category'];
    return SearchPage(query: query, category: category);
  },
),

// Usage: /search?q=flutter&category=tech
```

### Optional Parameters

```dart
GoRoute(
  path: '/product/:id?',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    if (id == null) return const ProductListPage();
    return ProductPage(productId: int.parse(id));
  },
),
```

---

## Nested Routes

```dart
GoRoute(
  path: '/dashboard',
  builder: (context, state) => const DashboardShell(),
  routes: [
    GoRoute(
      path: 'stats',
      builder: (context, state) => const StatsPage(),
    ),
    GoRoute(
      path: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: 'profile/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProfilePage(id: id);
      },
    ),
  ],
),

// Routes:
// /dashboard
// /dashboard/stats
// /dashboard/settings
// /dashboard/profile/123
```

---

## Navigation Patterns

### Programmatic Navigation

```dart
// Navigate to route
context.go('/home');
context.go(HomePage.routeName);

// Navigate with parameters
context.go('/product/${product.id}');

// Navigate with query params
context.go('/search?q=$query&category=$category');

// Push (add to stack)
context.push('/details');

// Replace current route
context.replace('/new-route');

// Go back
context.pop();
```

### Navigation from BLoC

```dart
// ❌ Don't use context in BLoC
// ✅ Use NavigationService or callback

// Option 1: Callback pattern
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.when(
      success: (_) => context.go(HomePage.routeName),
      failure: (msg) => showErrorSnackbar(context, msg),
      orElse: () {},
    );
  },
  child: /* ... */,
)

// Option 2: NavigationService (for non-UI triggered navigation)
@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final NavigationService _navigation;
  
  void _onSuccess() {
    _navigation.showSnackbar('Payment successful');
  }
}
```

---

## Route Guards

### Authentication Guard

```dart
redirect: (context, state) async {
  final authRepository = getIt<AuthRepository>();
  final isAuthenticated = await authRepository.isAuthenticated();
  final location = state.matchedLocation;
  
  // Public routes that don't require auth
  final publicRoutes = ['/login', '/register', '/forgot-password'];
  final isPublicRoute = publicRoutes.contains(location);
  
  if (!isAuthenticated && !isPublicRoute) {
    return '/login?redirect=${Uri.encodeComponent(location)}';
  }
  
  if (isAuthenticated && location == '/login') {
    return '/';
  }
  
  return null; // No redirect
},
```

### Role-Based Guard

```dart
redirect: (context, state) async {
  final userRepository = getIt<UserRepository>();
  final user = await userRepository.getCurrentUser();
  final location = state.matchedLocation;
  
  // Admin-only routes
  if (location.startsWith('/admin') && user.role != 'admin') {
    return '/unauthorized';
  }
  
  return null;
},
```

---

## Error Handling

### 404 Page

```dart
errorBuilder: (context, state) {
  return Scaffold(
    body: AppEmptyState.error(
      message: 'Page not found: ${state.uri}',
    ),
  );
},
```

### Deep Link Validation

```dart
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final idStr = state.pathParameters['id'];
    final id = int.tryParse(idStr ?? '');
    
    if (id == null) {
      return const InvalidProductPage();
    }
    
    return ProductPage(productId: id);
  },
),
```

---

## UI Integration

### MaterialApp.router

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      routerConfig: appRouter,
      // ... other config
    );
  }
}
```

### Bottom Navigation with ShellRoute

```dart
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExplorePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
  
  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }
  
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/');
      case 1: context.go('/explore');
      case 2: context.go('/profile');
    }
  }
}
```

---

## Deep Link Back Navigation

### The Problem

When navigating via `context.go()` from a deep link or FCM notification, pressing back exits the app because there's no navigation history.

```dart
// ❌ Problem: Back button exits app
context.go('/product/123');  // No history, back = exit
```

### Solutions

#### Option 1: Push Instead of Go (Recommended for Modal Flows)

Use `push()` when you want users to return to the previous screen:

```dart
// ✅ Better: User can go back to previous screen
context.push('/product/123');

// Or with parameters
context.push('/order/${order.id}');
```

#### Option 2: Ensure Home Route in Stack

Use `go()` with a stack that includes home route:

```dart
// Navigate but keep home route in stack
context.go('/');  // First go home
context.push('/product/123');  // Then push target
```

#### Option 3: Shell Route with Bottom Nav

For deep links into tabbed navigation, use `go()` with the correct tab:

```dart
// Navigate to specific tab with deep link
context.go('/explore/product/123');

// ShellRoute handles keeping other tabs in memory
```

#### Option 4: Custom Back Navigation Handler

In your page, handle back button to navigate home instead of exit:

```dart
class ProductPage extends StatelessWidget {
  final int productId;
  
  const ProductPage({required this.productId});
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If no history, go home instead of exit
        if (!context.canPop()) {
          context.go(HomePage.routeName);
          return false;  // Don't pop (we navigated instead)
        }
        return true;  // Allow normal pop
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: /* ... */,
      ),
    );
  }
}
```

#### Option 5: GoRouter Redirect with History Check

Check if coming from deep link and redirect to stack:

```dart
final appRouter = GoRouter(
  redirect: (context, state) {
    final isDeepLink = state.extra?['fromDeepLink'] == true;
    final isTargetRoute = state.matchedLocation.startsWith('/product');
    
    // If deep link to product and no history, go to home first
    if (isDeepLink && isTargetRoute && !context.canPop()) {
      return '/?then=${Uri.encodeComponent(state.matchedLocation)}';
    }
    return null;
  },
  routes: [ /* ... */ ],
);
```

### Recommended Pattern for FCM + Deep Links

```dart
void _handleNavigation(RemoteMessage message) {
  final data = message.data;
  final route = data['route'];
  final params = data['params'];
  final allowBack = data['allow_back'] != 'false';  // Default true
  
  final context = getIt<GoRouter>().routerDelegate.navigatorKey.currentContext;
  if (context == null) return;
  
  switch (route) {
    case 'product':
      final id = params['id']?.toString();
      if (id == null) return;
      
      if (allowBack) {
        // Push so user can go back
        context.push('/product/$id');
      } else {
        // Replace entire stack (e.g., from notification)
        context.go('/product/$id');
      }
      break;
      
    case 'order':
      // Always push orders - user might want to go back
      context.push('/orders/${params['id']}');
      break;
      
    case 'promotion':
      // Go to promotions (single screen, no back needed)
      context.go('/promotions');
      break;
  }
}
```

### Server Payload with Navigation Hint

```json
{
  "notification": {
    "title": "New Message",
    "body": "You have a new message"
  },
  "data": {
    "route": "chat",
    "params": "{\"id\": 123}",
    "allow_back": "true",
    "fallback_route": "/messages"
  }
}
```

---

## Best Practices

1. **Use static route constants** - Avoid magic strings
2. **Centralize router config** - Single source of truth
3. **Use redirect for guards** - Clean separation of concerns
4. **Parse params safely** - Handle invalid deep links
5. **Don't use context in BLoCs** - Use callbacks or NavigationService
6. **Test deep links** - Verify all URL patterns work

---

## Prohibited Patterns

❌ **Don't use Navigator directly:**
```dart
// WRONG
Navigator.of(context).push(MaterialPageRoute(...));

// CORRECT
context.go('/route');
```

❌ **Don't hardcode route strings:**
```dart
// WRONG
context.go('/home');

// CORRECT
context.go(HomePage.routeName);
```

❌ **Don't use context in BLoCs:**
```dart
// WRONG
class MyBloc extends Bloc {
  void navigate() => context.go('/home');
}
```
