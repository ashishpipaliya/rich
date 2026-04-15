---
name: notifications
description: "Implement Firebase push notifications in Flutter handling all app states: foreground, background, and terminated, with deep link routing."
---

# Firebase Push Notifications

## Role
Implement comprehensive push notification handling with FCM, supporting all app states (foreground, background, terminated) with deep linking and parameter extraction.

---

## Dependencies

```bash
flutter pub add firebase_core firebase_messaging flutter_local_notifications
```

> Always add via terminal — pub resolves the latest compatible versions automatically.

---

## Platform Setup

### Android

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
    <application>
        <!-- FCM default channel -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />
        
        <!-- Default icon -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />
        
        <!-- Default color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />
    </application>
</manifest>
```

### iOS

1. Enable Push Notifications in Xcode > Signing & Capabilities
2. Enable Background Modes: Remote Notifications
3. Add Notification Service Extension for rich notifications

```swift
// ios/Runner/AppDelegate.swift
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle APNs token
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }
}
```

---

## Core Implementation

### Notification Service

```dart
// core/notifications/notification_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../di/injection.dart';
import '../router/app_router.dart';

@lazySingleton
class NotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications;
  
  // Stream controllers for notification events
  final _foregroundController = StreamController<RemoteMessage>.broadcast();
  final _backgroundController = StreamController<RemoteMessage>.broadcast();
  final _tapController = StreamController<RemoteMessage>.broadcast();
  
  Stream<RemoteMessage> get onForegroundMessage => _foregroundController.stream;
  Stream<RemoteMessage> get onBackgroundMessage => _backgroundController.stream;
  Stream<RemoteMessage> get onNotificationTap => _tapController.stream;

  NotificationService()
      : _fcm = FirebaseMessaging.instance,
        _localNotifications = FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  Future<void> initialize() async {
    // Request permission (iOS)
    await _requestPermission();
    
    // Initialize local notifications for foreground
    await _initializeLocalNotifications();
    
    // Get FCM token
    await _getToken();
    
    // Listen to token refresh
    _fcm.onTokenRefresh.listen(_onTokenRefresh);
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background/terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check if app was opened from terminated state
    await _checkInitialMessage();
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
    );
    
    if (kDebugMode) {
      print('Notification permission: ${settings.authorizationStatus}');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
    
    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  /// Create high importance notification channel for Android
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Get FCM token
  Future<String?> _getToken() async {
    final token = await _fcm.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }
    // Send token to your server
    await _sendTokenToServer(token);
    return token;
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String token) async {
    if (kDebugMode) {
      print('FCM Token refreshed: $token');
    }
    await _sendTokenToServer(token);
  }

  /// Send token to backend
  Future<void> _sendTokenToServer(String? token) async {
    // TODO: Implement API call to save token
    // await getIt<AuthRepository>().updateFcmToken(token);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _foregroundController.add(message);
    
    // Show local notification for foreground
    await _showLocalNotification(message);
    
    _logMessage('Foreground', message);
  }

  /// Show local notification (for foreground)
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    
    if (notification == null) return;
    
    final androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      icon: android?.smallIcon ?? '@drawable/ic_notification',
      largeIcon: android?.imageUrl != null
          ? FilePathAndroidBitmap(android!.imageUrl!)
          : null,
    );
    
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    
    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle local notification tap
  void _onLocalNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;
    
    final data = jsonDecode(response.payload!) as Map<String, dynamic>;
    final message = RemoteMessage(data: data);
    _tapController.add(message);
    _handleNavigation(message);
  }

  /// Handle message opened app (background/foreground)
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    _tapController.add(message);
    _handleNavigation(message);
  }

  /// Check initial message (app terminated)
  Future<void> _checkInitialMessage() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      _tapController.add(message);
      // Delay navigation until app is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNavigation(message);
      });
    }
  }

  /// Handle navigation from notification
  void _handleNavigation(RemoteMessage message) {
    final data = message.data;
    final route = data['route'];
    final params = data['params'];
    
    if (route == null) return;
    
    // Parse params if provided
    Map<String, dynamic> routeParams = {};
    if (params != null && params is String) {
      routeParams = jsonDecode(params);
    }
    
    // Navigate using GoRouter
    final context = getIt<GoRouter>().routerDelegate.navigatorKey.currentContext;
    if (context != null) {
      _navigate(context, route, routeParams);
    }
  }

  /// Navigate to specific route
  void _navigate(BuildContext context, String route, Map<String, dynamic> params) {
    switch (route) {
      case 'product':
        final id = params['id']?.toString();
        if (id != null) {
          context.go('/product/$id');
        }
        break;
      case 'order':
        final id = params['id']?.toString();
        if (id != null) {
          context.go('/orders/$id');
        }
        break;
      case 'chat':
        final id = params['id']?.toString();
        if (id != null) {
          context.go('/chat/$id');
        }
        break;
      case 'profile':
        context.go('/profile');
        break;
      default:
        context.go(route);
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    await _fcm.deleteToken();
  }

  void _logMessage(String state, RemoteMessage message) {
    if (kDebugMode) {
      print('📬 [$state] Notification:');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
    }
  }

  void dispose() {
    _foregroundController.close();
    _backgroundController.close();
    _tapController.close();
  }
}
```

---

## Background Handler

```dart
// core/notifications/background_handler.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../firebase_options.dart';

/// Background message handler (MUST be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background isolate
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log('📬 [Background] Notification received:');
  log('   Title: ${message.notification?.title}');
  log('   Body: ${message.notification?.body}');
  log('   Data: ${message.data}');

  // Handle background logic here
  // - Save to local database
  // - Update badge count
  // - Show local notification (optional, FCM handles this automatically)
  
  await _handleBackgroundMessage(message);
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  final data = message.data;
  
  // Example: Update badge count
  final type = data['type'];
  
  switch (type) {
    case 'new_message':
      // Increment unread message count
      await _updateBadgeCount('messages');
      break;
    case 'new_order':
      // Increment order notification count
      await _updateBadgeCount('orders');
      break;
    case 'promotion':
      // Handle promotional notification
      break;
  }
}

Future<void> _updateBadgeCount(String key) async {
  // Implement with Hive or SharedPreferences
  // final prefs = await SharedPreferences.getInstance();
  // final current = prefs.getInt('badge_$key') ?? 0;
  // await prefs.setInt('badge_$key', current + 1);
}
```

---

## Notification Handler Widget

```dart
// core/notifications/notification_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_service.dart';

/// Widget that handles notification routing and UI effects
class NotificationHandler extends StatefulWidget {
  final Widget child;

  const NotificationHandler({required this.child});

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = context.read<NotificationService>();
    _initialize();
  }

  Future<void> _initialize() async {
    await _notificationService.initialize();
    
    // Listen to foreground messages for UI updates
    _notificationService.onForegroundMessage.listen(_onForegroundMessage);
    
    // Listen to notification taps
    _notificationService.onNotificationTap.listen(_onNotificationTap);
  }

  void _onForegroundMessage(message) {
    // Show in-app snackbar or update UI
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.body ?? 'New notification'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () => _handleTap(message),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _onNotificationTap(message) {
    // Navigation handled by NotificationService
    // Additional UI logic can be added here
  }

  void _handleTap(message) {
    // Manual handling if needed
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
```

---

## Usage in main.dart

```dart
// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/notifications/background_handler.dart';
import 'core/notifications/notification_handler.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set background handler BEFORE configuring dependencies
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // Configure DI
  await configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide NotificationService for access across app
        RepositoryProvider.value(value: getIt<NotificationService>()),
      ],
      child: NotificationHandler(
        child: MaterialApp.router(
          title: 'My App',
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
```

---

## FCM Payload Format

### Simple Notification

```json
{
  "notification": {
    "title": "New Order",
    "body": "You have received a new order #1234"
  },
  "data": {
    "route": "order",
    "params": "{\"id\": 1234}",
    "type": "new_order"
  }
}
```

### With Image

```json
{
  "notification": {
    "title": "Product Update",
    "body": "Check out this new product!",
    "image": "https://example.com/image.jpg"
  },
  "data": {
    "route": "product",
    "params": "{\"id\": 567}",
    "type": "promotion"
  }
}
```

### Silent Data Message (No UI)

```json
{
  "data": {
    "type": "sync",
    "action": "refresh_cache",
    "timestamp": "2024-01-01T00:00:00Z"
  },
  "notification": null
}
```

### Multi-Recipient

```json
{
  "notification": {
    "title": "Flash Sale!",
    "body": "50% off all items for the next 2 hours!"
  },
  "data": {
    "route": "/shop/flash-sale",
    "type": "promotion"
  },
  "topic": "all_users"
}
```

---

## Advanced Features

### Scheduled Notifications

```dart
// Using FCM or local notifications
Future<void> scheduleLocalNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
}) async {
  final tz = await _getTimeZone();
  
  await _localNotifications.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledDate, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

### Notification Categories (iOS)

```dart
// iOS notification categories with actions
Future<void> _setupNotificationCategories() async {
  const replyAction = DarwinNotificationAction(
    'reply',
    'Reply',
    options: {DarwinNotificationActionOption.foreground},
  );
  
  const dismissAction = DarwinNotificationAction(
    'dismiss',
    'Dismiss',
    options: {DarwinNotificationActionOption.destructive},
  );
  
  const messageCategory = DarwinNotificationCategory(
    'message',
    actions: [replyAction, dismissAction],
  );
  
  await _localNotifications.initialize(
    settings,
    onDidReceiveNotificationResponse: _onNotificationResponse,
  );
}
```

### Badge Management

```dart
Future<void> _updateAppBadge(int count) async {
  if (Platform.isIOS) {
    await _localNotifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.updateBadgeCount(count);
  }
}
```

---

## Best Practices

1. **Request permission early** - But not on first launch, wait for relevant moment
2. **Handle all states** - Foreground, background, terminated
3. **Test on real devices** - Simulators don't support all features
4. **Use data payload for routing** - Keep notification payload simple
5. **Implement deduplication** - Check notification ID before processing
6. **Respect user preferences** - Allow opting out of notification types
7. **Log and monitor** - Track delivery and open rates
8. **Handle edge cases** - Large images, malformed data, network issues

---

## Prohibited Patterns

❌ **Don't handle navigation in background handler:**
```dart
// ❌ Wrong - can't navigate from background
@pragma('vm:entry-point')
void backgroundHandler(RemoteMessage message) {
  Navigator.push(...);  // Won't work!
}
```

❌ **Don't store context in service:**
```dart
// ❌ Wrong
class NotificationService {
  BuildContext? context;  // Memory leak risk
}
```

❌ **Don't ignore iOS permissions:**
```dart
// ❌ Wrong - will fail on iOS
FirebaseMessaging.onMessage.listen(...);  // Without requesting permission
```

❌ **Don't use synchronous token retrieval:**
```dart
// ❌ Wrong - token might not be ready
final token = await FirebaseMessaging.instance.getToken();
await api.sendToken(token);  // Could be null
```

# Firebase Push Notifications

## Role
Implement comprehensive push notification handling with FCM, supporting all app states (foreground, background, terminated) with deep linking and parameter extraction.

---

## Dependencies

```bash
flutter pub add firebase_core firebase_messaging flutter_local_notifications
```

> Always add via terminal — pub resolves the latest compatible versions automatically.

---

## Platform Setup

### Android

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
    <application>
        <!-- FCM default channel -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />
        
        <!-- Default icon -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />
        
        <!-- Default color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />
    </application>
</manifest>
```

### iOS

1. Enable Push Notifications in Xcode > Signing & Capabilities
2. Enable Background Modes: Remote Notifications
3. Add Notification Service Extension for rich notifications

```swift
// ios/Runner/AppDelegate.swift
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle APNs token
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }
}
```

---

## Core Implementation

### Notification Service

```dart
// core/notifications/notification_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../di/injection.dart';
import '../router/app_router.dart';

@lazySingleton
class NotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications;
  
  // Stream controllers for notification events
  final _foregroundController = StreamController<RemoteMessage>.broadcast();
  final _backgroundController = StreamController<RemoteMessage>.broadcast();
  final _tapController = StreamController<RemoteMessage>.broadcast();
  
  Stream<RemoteMessage> get onForegroundMessage => _foregroundController.stream;
  Stream<RemoteMessage> get onBackgroundMessage => _backgroundController.stream;
  Stream<RemoteMessage> get onNotificationTap => _tapController.stream;

  NotificationService()
      : _fcm = FirebaseMessaging.instance,
        _localNotifications = FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  Future<void> initialize() async {
    // Request permission (iOS)
    await _requestPermission();
    
    // Initialize local notifications for foreground
    await _initializeLocalNotifications();
    
    // Get FCM token
    await _getToken();
    
    // Listen to token refresh
    _fcm.onTokenRefresh.listen(_onTokenRefresh);
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background/terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check if app was opened from terminated state
    await _checkInitialMessage();
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
    );
    
    if (kDebugMode) {
      print('Notification permission: ${settings.authorizationStatus}');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
    
    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  /// Create high importance notification channel for Android
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Get FCM token
  Future<String?> _getToken() async {
    final token = await _fcm.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }
    // Send token to your server
    await _sendTokenToServer(token);
    return token;
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String token) async {
    if (kDebugMode) {
      print('FCM Token refreshed: $token');
    }
    await _sendTokenToServer(token);
  }

  /// Send token to backend
  Future<void> _sendTokenToServer(String? token) async {
    // TODO: Implement API call to save token
    // await getIt<AuthRepository>().updateFcmToken(token);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _foregroundController.add(message);
    
    // Show local notification for foreground
    await _showLocalNotification(message);
    
    _logMessage('Foreground', message);
  }

  /// Show local notification (for foreground)
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    
    if (notification == null) return;
    
    final androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      icon: android?.smallIcon ?? '@drawable/ic_notification',
      largeIcon: android?.imageUrl != null
          ? FilePathAndroidBitmap(android!.imageUrl!)
          : null,
    );
    
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    
    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle local notification tap
  void _onLocalNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;
    
    final data = jsonDecode(response.payload!) as Map<String, dynamic>;
    final message = RemoteMessage(data: data);
    _tapController.add(message);
    _handleNavigation(message);
  }

  /// Handle message opened app (background/foreground)
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    _tapController.add(message);
    _handleNavigation(message);
  }

  /// Check initial message (app terminated)
  Future<void> _checkInitialMessage() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      _tapController.add(message);
      // Delay navigation until app is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNavigation(message);
      });
    }
  }

  /// Handle navigation from notification
  void _handleNavigation(RemoteMessage message) {
    final data = message.data;
    final route = data['route'];
    final params = data['params'];
    
    if (route == null) return;
    
    // Parse params if provided
    Map<String, dynamic> routeParams = {};
    if (params != null && params is String) {
      routeParams = jsonDecode(params);
    }
    
    // Navigate using GoRouter
    final context = getIt<GoRouter>().routerDelegate.navigatorKey.currentContext;
    if (context != null) {
      _navigate(context, route, routeParams);
    }
  }

  /// Navigate to specific route
  void _navigate(BuildContext context, String route, Map<String, dynamic> params) {
    switch (route) {
      case 'product':
        final id = params['id']?.toString();
        if (id != null) {
          context.go('/product/$id');
        }
        break;
      case 'order':
        final id = params['id']?.toString();
        if (id != null) {
          context.go('/orders/$id');
        }
        break;
      case 'chat':
        final id = params['id']?.toString();
        if (id != null) {
          context.go('/chat/$id');
        }
        break;
      case 'profile':
        context.go('/profile');
        break;
      default:
        context.go(route);
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    await _fcm.deleteToken();
  }

  void _logMessage(String state, RemoteMessage message) {
    if (kDebugMode) {
      print('📬 [$state] Notification:');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
    }
  }

  void dispose() {
    _foregroundController.close();
    _backgroundController.close();
    _tapController.close();
  }
}
```

---

## Background Handler

```dart
// core/notifications/background_handler.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../firebase_options.dart';

/// Background message handler (MUST be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background isolate
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log('📬 [Background] Notification received:');
  log('   Title: ${message.notification?.title}');
  log('   Body: ${message.notification?.body}');
  log('   Data: ${message.data}');

  // Handle background logic here
  // - Save to local database
  // - Update badge count
  // - Show local notification (optional, FCM handles this automatically)
  
  await _handleBackgroundMessage(message);
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  final data = message.data;
  
  // Example: Update badge count
  final type = data['type'];
  
  switch (type) {
    case 'new_message':
      // Increment unread message count
      await _updateBadgeCount('messages');
      break;
    case 'new_order':
      // Increment order notification count
      await _updateBadgeCount('orders');
      break;
    case 'promotion':
      // Handle promotional notification
      break;
  }
}

Future<void> _updateBadgeCount(String key) async {
  // Implement with Hive or SharedPreferences
  // final prefs = await SharedPreferences.getInstance();
  // final current = prefs.getInt('badge_$key') ?? 0;
  // await prefs.setInt('badge_$key', current + 1);
}
```

---

## Notification Handler Widget

```dart
// core/notifications/notification_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_service.dart';

/// Widget that handles notification routing and UI effects
class NotificationHandler extends StatefulWidget {
  final Widget child;

  const NotificationHandler({required this.child});

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = context.read<NotificationService>();
    _initialize();
  }

  Future<void> _initialize() async {
    await _notificationService.initialize();
    
    // Listen to foreground messages for UI updates
    _notificationService.onForegroundMessage.listen(_onForegroundMessage);
    
    // Listen to notification taps
    _notificationService.onNotificationTap.listen(_onNotificationTap);
  }

  void _onForegroundMessage(message) {
    // Show in-app snackbar or update UI
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.body ?? 'New notification'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () => _handleTap(message),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _onNotificationTap(message) {
    // Navigation handled by NotificationService
    // Additional UI logic can be added here
  }

  void _handleTap(message) {
    // Manual handling if needed
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
```

---

## Usage in main.dart

```dart
// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/notifications/background_handler.dart';
import 'core/notifications/notification_handler.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set background handler BEFORE configuring dependencies
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // Configure DI
  await configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide NotificationService for access across app
        RepositoryProvider.value(value: getIt<NotificationService>()),
      ],
      child: NotificationHandler(
        child: MaterialApp.router(
          title: 'My App',
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
```

---

## FCM Payload Format

### Simple Notification

```json
{
  "notification": {
    "title": "New Order",
    "body": "You have received a new order #1234"
  },
  "data": {
    "route": "order",
    "params": "{\"id\": 1234}",
    "type": "new_order"
  }
}
```

### With Image

```json
{
  "notification": {
    "title": "Product Update",
    "body": "Check out this new product!",
    "image": "https://example.com/image.jpg"
  },
  "data": {
    "route": "product",
    "params": "{\"id\": 567}",
    "type": "promotion"
  }
}
```

### Silent Data Message (No UI)

```json
{
  "data": {
    "type": "sync",
    "action": "refresh_cache",
    "timestamp": "2024-01-01T00:00:00Z"
  },
  "notification": null
}
```

### Multi-Recipient

```json
{
  "notification": {
    "title": "Flash Sale!",
    "body": "50% off all items for the next 2 hours!"
  },
  "data": {
    "route": "/shop/flash-sale",
    "type": "promotion"
  },
  "topic": "all_users"
}
```

---

## Advanced Features

### Scheduled Notifications

```dart
// Using FCM or local notifications
Future<void> scheduleLocalNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
}) async {
  final tz = await _getTimeZone();
  
  await _localNotifications.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledDate, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

### Notification Categories (iOS)

```dart
// iOS notification categories with actions
Future<void> _setupNotificationCategories() async {
  const replyAction = DarwinNotificationAction(
    'reply',
    'Reply',
    options: {DarwinNotificationActionOption.foreground},
  );
  
  const dismissAction = DarwinNotificationAction(
    'dismiss',
    'Dismiss',
    options: {DarwinNotificationActionOption.destructive},
  );
  
  const messageCategory = DarwinNotificationCategory(
    'message',
    actions: [replyAction, dismissAction],
  );
  
  await _localNotifications.initialize(
    settings,
    onDidReceiveNotificationResponse: _onNotificationResponse,
  );
}
```

### Badge Management

```dart
Future<void> _updateAppBadge(int count) async {
  if (Platform.isIOS) {
    await _localNotifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.updateBadgeCount(count);
  }
}
```

---

## Best Practices

1. **Request permission early** - But not on first launch, wait for relevant moment
2. **Handle all states** - Foreground, background, terminated
3. **Test on real devices** - Simulators don't support all features
4. **Use data payload for routing** - Keep notification payload simple
5. **Implement deduplication** - Check notification ID before processing
6. **Respect user preferences** - Allow opting out of notification types
7. **Log and monitor** - Track delivery and open rates
8. **Handle edge cases** - Large images, malformed data, network issues

---

## Prohibited Patterns

❌ **Don't handle navigation in background handler:**
```dart
// ❌ Wrong - can't navigate from background
@pragma('vm:entry-point')
void backgroundHandler(RemoteMessage message) {
  Navigator.push(...);  // Won't work!
}
```

❌ **Don't store context in service:**
```dart
// ❌ Wrong
class NotificationService {
  BuildContext? context;  // Memory leak risk
}
```

❌ **Don't ignore iOS permissions:**
```dart
// ❌ Wrong - will fail on iOS
FirebaseMessaging.onMessage.listen(...);  // Without requesting permission
```

❌ **Don't use synchronous token retrieval:**
```dart
// ❌ Wrong - token might not be ready
final token = await FirebaseMessaging.instance.getToken();
await api.sendToken(token);  // Could be null
```
