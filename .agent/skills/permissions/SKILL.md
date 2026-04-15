---
name: permissions
description: "Handle platform permissions in Flutter (camera, location, storage, etc.) with a unified PermissionService and user-friendly rationale dialogs."
---

# Flutter Permissions Handler

## Role
Handle platform permissions (camera, location, storage, etc.) with a unified service, status tracking, and user-friendly permission dialogs.

---

## Dependencies

```bash
flutter pub add permission_handler app_settings
```

> Always add via terminal — pub resolves the latest compatible versions automatically.

---

## Permission Service

```dart
// core/permissions/permission_service.dart
import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class PermissionService {
  /// Check if permission is granted
  Future<bool> isGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Request single permission with dialog
  Future<bool> request(
    BuildContext context,
    Permission permission, {
    String? title,
    String? message,
    String? icon,
  }) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      return await _showPermissionDialog(
        context,
        permission,
        title: title ?? _getDefaultTitle(permission),
        message: message ?? _getDefaultMessage(permission),
        icon: icon ?? _getDefaultIcon(permission),
      );
    }

    if (status.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        title: title ?? _getDefaultTitle(permission),
        message: 'This permission is permanently denied. Please enable it in app settings.',
      );
    }

    return false;
  }

  /// Request multiple permissions
  Future<Map<Permission, bool>> requestMultiple(
    BuildContext context,
    List<Permission> permissions, {
    String? title,
    String? message,
  }) async {
    final results = <Permission, bool>{};

    for (final permission in permissions) {
      results[permission] = await request(
        context,
        permission,
        title: title,
        message: message,
      );
    }

    return results;
  }

  /// Show permission rationale dialog
  Future<bool> _showPermissionDialog(
    BuildContext context,
    Permission permission, {
    required String title,
    required String message,
    required String icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialog(
        title: title,
        message: message,
        icon: icon,
        onContinue: () async {
          final status = await permission.request();
          Navigator.of(context).pop(status.isGranted);
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    return result ?? false;
  }

  /// Show settings dialog for permanently denied permissions
  Future<bool> _showSettingsDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await AppSettings.openAppSettings();
              Navigator.of(context).pop(true);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Open app settings
  Future<void> openSettings() async {
    await AppSettings.openAppSettings();
  }

  /// Check and request camera permission
  Future<bool> requestCamera(BuildContext context) async {
    return await request(
      context,
      Permission.camera,
      title: 'Camera Access',
      message: 'This app needs camera access to take photos and scan QR codes.',
      icon: '📷',
    );
  }

  /// Check and request photo library permission
  Future<bool> requestPhotos(BuildContext context) async {
    return await request(
      context,
      Permission.photos,
      title: 'Photo Library',
      message: 'This app needs access to your photos to upload images.',
      icon: '🖼️',
    );
  }

  /// Check and request location permission
  Future<bool> requestLocation(BuildContext context) async {
    return await request(
      context,
      Permission.location,
      title: 'Location Access',
      message: 'This app needs your location to show nearby places and provide directions.',
      icon: '📍',
    );
  }

  /// Check and request location when in use
  Future<bool> requestLocationWhenInUse(BuildContext context) async {
    return await request(
      context,
      Permission.locationWhenInUse,
      title: 'Location Access',
      message: 'This app needs your location while using the app.',
      icon: '📍',
    );
  }

  /// Check and request location always
  Future<bool> requestLocationAlways(BuildContext context) async {
    return await request(
      context,
      Permission.locationAlways,
      title: 'Background Location',
      message: 'This app needs location access even when in background for tracking.',
      icon: '📍',
    );
  }

  /// Check and request microphone permission
  Future<bool> requestMicrophone(BuildContext context) async {
    return await request(
      context,
      Permission.microphone,
      title: 'Microphone Access',
      message: 'This app needs microphone access for voice messages and calls.',
      icon: '🎤',
    );
  }

  /// Check and request storage permission
  Future<bool> requestStorage(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await request(
        context,
        Permission.storage,
        title: 'Storage Access',
        message: 'This app needs storage access to save files and cache data.',
        icon: '💾',
      );
    }
    // iOS uses different permissions
    return true;
  }

  /// Check and request notification permission
  Future<bool> requestNotifications(BuildContext context) async {
    return await request(
      context,
      Permission.notification,
      title: 'Notifications',
      message: 'Enable notifications to receive updates and alerts.',
      icon: '🔔',
    );
  }

  /// Check and request contacts permission
  Future<bool> requestContacts(BuildContext context) async {
    return await request(
      context,
      Permission.contacts,
      title: 'Contacts Access',
      message: 'This app needs access to your contacts to find friends.',
      icon: '👥',
    );
  }

  /// Check and request calendar permission
  Future<bool> requestCalendar(BuildContext context) async {
    return await request(
      context,
      Permission.calendar,
      title: 'Calendar Access',
      message: 'This app needs calendar access to add events and reminders.',
      icon: '📅',
    );
  }

  String _getDefaultTitle(Permission permission) {
    return switch (permission) {
      Permission.camera => 'Camera Access',
      Permission.photos => 'Photo Library',
      Permission.location || Permission.locationWhenInUse => 'Location',
      Permission.locationAlways => 'Background Location',
      Permission.microphone => 'Microphone',
      Permission.storage || Permission.photosAddOnly => 'Storage',
      Permission.notification => 'Notifications',
      Permission.contacts => 'Contacts',
      Permission.calendar => 'Calendar',
      _ => 'Permission Required',
    };
  }

  String _getDefaultMessage(Permission permission) {
    return 'This app needs ${permission.toString().split('.').last} permission to function properly.';
  }

  String _getDefaultIcon(Permission permission) {
    return switch (permission) {
      Permission.camera => '📷',
      Permission.photos => '🖼️',
      Permission.location || Permission.locationWhenInUse || Permission.locationAlways => '📍',
      Permission.microphone => '🎤',
      Permission.storage => '💾',
      Permission.notification => '🔔',
      Permission.contacts => '👥',
      Permission.calendar => '📅',
      _ => '🔒',
    };
  }
}
```

---

## Permission Dialog UI

```dart
// core/permissions/widgets/permission_dialog.dart
class PermissionDialog extends StatelessWidget {
  final String title;
  final String message;
  final String icon;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const PermissionDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.onContinue,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinue,
                    child: const Text('Allow'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Pre-Permission Rationale Widget

```dart
// core/permissions/widgets/permission_rationale.dart
class PermissionRationale extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final VoidCallback onRequest;

  const PermissionRationale({
    required this.title,
    required this.description,
    required this.icon,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Text(icon, style: const TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRequest,
              icon: const Icon(Icons.check),
              label: const Text('Grant Permission'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Usage Examples

### Basic Permission Request

```dart
class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final granted = await getIt<PermissionService>().requestCamera(context);
            if (granted) {
              // Open camera
              context.push('/camera/view');
            }
          },
          child: const Text('Open Camera'),
        ),
      ),
    );
  }
}
```

### Permission Gate (Rationale First)

```dart
class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getIt<PermissionService>().isGranted(Permission.photos),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return const GalleryGrid();
        }
        
        return PermissionRationale(
          title: 'Photo Gallery Access',
          description: 'We need access to your photos to upload and share images with your contacts.',
          icon: '🖼️',
          onRequest: () async {
            final granted = await getIt<PermissionService>().requestPhotos(context);
            if (granted) {
              // Refresh page
            }
          },
        );
      },
    );
  }
}
```

### Multiple Permissions

```dart
class CreatePostPage extends StatelessWidget {
  Future<void> _createPost(BuildContext context) async {
    final results = await getIt<PermissionService>().requestMultiple(
      context,
      [Permission.camera, Permission.photos, Permission.locationWhenInUse],
      title: 'Create Post',
      message: 'We need a few permissions to create your post with location.',
    );

    final allGranted = results.values.every((granted) => granted);
    
    if (allGranted) {
      context.push('/post/create');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some permissions were denied. Limited functionality.')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) { }
}
```

---

## Best Practices

1. **Request permissions in context** - Ask when user tries to use feature, not at app start
2. **Show rationale first** - Explain why permission is needed before requesting
3. **Handle permanently denied** - Guide users to settings with helpful dialog
4. **Graceful degradation** - App should work without optional permissions
5. **Don't spam requests** - Only request once per session, track user preference

---

## Prohibited Patterns

❌ **Don't request all permissions at startup:**
```dart
// ❌ Bad
void main() async {
  await Permission.camera.request();
  await Permission.location.request();
  await Permission.contacts.request();
  runApp(MyApp());
}
```

❌ **Don't request without context:**
```dart
// ❌ Bad
class BadService {
  void init() async {
    await Permission.camera.request();  // No context, no rationale
  }
}
```

❌ **Don't ignore permanently denied:**
```dart
// ❌ Bad
if (status.isPermanentlyDenied) {
  return;  // User stuck, no guidance
}
```

# Flutter Permissions Handler

## Role
Handle platform permissions (camera, location, storage, etc.) with a unified service, status tracking, and user-friendly permission dialogs.

---

## Dependencies

```bash
flutter pub add permission_handler app_settings
```

> Always add via terminal — pub resolves the latest compatible versions automatically.

---

## Permission Service

```dart
// core/permissions/permission_service.dart
import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class PermissionService {
  /// Check if permission is granted
  Future<bool> isGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Request single permission with dialog
  Future<bool> request(
    BuildContext context,
    Permission permission, {
    String? title,
    String? message,
    String? icon,
  }) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      return await _showPermissionDialog(
        context,
        permission,
        title: title ?? _getDefaultTitle(permission),
        message: message ?? _getDefaultMessage(permission),
        icon: icon ?? _getDefaultIcon(permission),
      );
    }

    if (status.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        title: title ?? _getDefaultTitle(permission),
        message: 'This permission is permanently denied. Please enable it in app settings.',
      );
    }

    return false;
  }

  /// Request multiple permissions
  Future<Map<Permission, bool>> requestMultiple(
    BuildContext context,
    List<Permission> permissions, {
    String? title,
    String? message,
  }) async {
    final results = <Permission, bool>{};

    for (final permission in permissions) {
      results[permission] = await request(
        context,
        permission,
        title: title,
        message: message,
      );
    }

    return results;
  }

  /// Show permission rationale dialog
  Future<bool> _showPermissionDialog(
    BuildContext context,
    Permission permission, {
    required String title,
    required String message,
    required String icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialog(
        title: title,
        message: message,
        icon: icon,
        onContinue: () async {
          final status = await permission.request();
          Navigator.of(context).pop(status.isGranted);
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    return result ?? false;
  }

  /// Show settings dialog for permanently denied permissions
  Future<bool> _showSettingsDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await AppSettings.openAppSettings();
              Navigator.of(context).pop(true);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Open app settings
  Future<void> openSettings() async {
    await AppSettings.openAppSettings();
  }

  /// Check and request camera permission
  Future<bool> requestCamera(BuildContext context) async {
    return await request(
      context,
      Permission.camera,
      title: 'Camera Access',
      message: 'This app needs camera access to take photos and scan QR codes.',
      icon: '📷',
    );
  }

  /// Check and request photo library permission
  Future<bool> requestPhotos(BuildContext context) async {
    return await request(
      context,
      Permission.photos,
      title: 'Photo Library',
      message: 'This app needs access to your photos to upload images.',
      icon: '🖼️',
    );
  }

  /// Check and request location permission
  Future<bool> requestLocation(BuildContext context) async {
    return await request(
      context,
      Permission.location,
      title: 'Location Access',
      message: 'This app needs your location to show nearby places and provide directions.',
      icon: '📍',
    );
  }

  /// Check and request location when in use
  Future<bool> requestLocationWhenInUse(BuildContext context) async {
    return await request(
      context,
      Permission.locationWhenInUse,
      title: 'Location Access',
      message: 'This app needs your location while using the app.',
      icon: '📍',
    );
  }

  /// Check and request location always
  Future<bool> requestLocationAlways(BuildContext context) async {
    return await request(
      context,
      Permission.locationAlways,
      title: 'Background Location',
      message: 'This app needs location access even when in background for tracking.',
      icon: '📍',
    );
  }

  /// Check and request microphone permission
  Future<bool> requestMicrophone(BuildContext context) async {
    return await request(
      context,
      Permission.microphone,
      title: 'Microphone Access',
      message: 'This app needs microphone access for voice messages and calls.',
      icon: '🎤',
    );
  }

  /// Check and request storage permission
  Future<bool> requestStorage(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await request(
        context,
        Permission.storage,
        title: 'Storage Access',
        message: 'This app needs storage access to save files and cache data.',
        icon: '💾',
      );
    }
    // iOS uses different permissions
    return true;
  }

  /// Check and request notification permission
  Future<bool> requestNotifications(BuildContext context) async {
    return await request(
      context,
      Permission.notification,
      title: 'Notifications',
      message: 'Enable notifications to receive updates and alerts.',
      icon: '🔔',
    );
  }

  /// Check and request contacts permission
  Future<bool> requestContacts(BuildContext context) async {
    return await request(
      context,
      Permission.contacts,
      title: 'Contacts Access',
      message: 'This app needs access to your contacts to find friends.',
      icon: '👥',
    );
  }

  /// Check and request calendar permission
  Future<bool> requestCalendar(BuildContext context) async {
    return await request(
      context,
      Permission.calendar,
      title: 'Calendar Access',
      message: 'This app needs calendar access to add events and reminders.',
      icon: '📅',
    );
  }

  String _getDefaultTitle(Permission permission) {
    return switch (permission) {
      Permission.camera => 'Camera Access',
      Permission.photos => 'Photo Library',
      Permission.location || Permission.locationWhenInUse => 'Location',
      Permission.locationAlways => 'Background Location',
      Permission.microphone => 'Microphone',
      Permission.storage || Permission.photosAddOnly => 'Storage',
      Permission.notification => 'Notifications',
      Permission.contacts => 'Contacts',
      Permission.calendar => 'Calendar',
      _ => 'Permission Required',
    };
  }

  String _getDefaultMessage(Permission permission) {
    return 'This app needs ${permission.toString().split('.').last} permission to function properly.';
  }

  String _getDefaultIcon(Permission permission) {
    return switch (permission) {
      Permission.camera => '📷',
      Permission.photos => '🖼️',
      Permission.location || Permission.locationWhenInUse || Permission.locationAlways => '📍',
      Permission.microphone => '🎤',
      Permission.storage => '💾',
      Permission.notification => '🔔',
      Permission.contacts => '👥',
      Permission.calendar => '📅',
      _ => '🔒',
    };
  }
}
```

---

## Permission Dialog UI

```dart
// core/permissions/widgets/permission_dialog.dart
class PermissionDialog extends StatelessWidget {
  final String title;
  final String message;
  final String icon;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const PermissionDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.onContinue,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinue,
                    child: const Text('Allow'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Pre-Permission Rationale Widget

```dart
// core/permissions/widgets/permission_rationale.dart
class PermissionRationale extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final VoidCallback onRequest;

  const PermissionRationale({
    required this.title,
    required this.description,
    required this.icon,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Text(icon, style: const TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRequest,
              icon: const Icon(Icons.check),
              label: const Text('Grant Permission'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Usage Examples

### Basic Permission Request

```dart
class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final granted = await getIt<PermissionService>().requestCamera(context);
            if (granted) {
              // Open camera
              context.push('/camera/view');
            }
          },
          child: const Text('Open Camera'),
        ),
      ),
    );
  }
}
```

### Permission Gate (Rationale First)

```dart
class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getIt<PermissionService>().isGranted(Permission.photos),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return const GalleryGrid();
        }
        
        return PermissionRationale(
          title: 'Photo Gallery Access',
          description: 'We need access to your photos to upload and share images with your contacts.',
          icon: '🖼️',
          onRequest: () async {
            final granted = await getIt<PermissionService>().requestPhotos(context);
            if (granted) {
              // Refresh page
            }
          },
        );
      },
    );
  }
}
```

### Multiple Permissions

```dart
class CreatePostPage extends StatelessWidget {
  Future<void> _createPost(BuildContext context) async {
    final results = await getIt<PermissionService>().requestMultiple(
      context,
      [Permission.camera, Permission.photos, Permission.locationWhenInUse],
      title: 'Create Post',
      message: 'We need a few permissions to create your post with location.',
    );

    final allGranted = results.values.every((granted) => granted);
    
    if (allGranted) {
      context.push('/post/create');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some permissions were denied. Limited functionality.')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) { }
}
```

---

## Best Practices

1. **Request permissions in context** - Ask when user tries to use feature, not at app start
2. **Show rationale first** - Explain why permission is needed before requesting
3. **Handle permanently denied** - Guide users to settings with helpful dialog
4. **Graceful degradation** - App should work without optional permissions
5. **Don't spam requests** - Only request once per session, track user preference

---

## Prohibited Patterns

❌ **Don't request all permissions at startup:**
```dart
// ❌ Bad
void main() async {
  await Permission.camera.request();
  await Permission.location.request();
  await Permission.contacts.request();
  runApp(MyApp());
}
```

❌ **Don't request without context:**
```dart
// ❌ Bad
class BadService {
  void init() async {
    await Permission.camera.request();  // No context, no rationale
  }
}
```

❌ **Don't ignore permanently denied:**
```dart
// ❌ Bad
if (status.isPermanentlyDenied) {
  return;  // User stuck, no guidance
}
```
