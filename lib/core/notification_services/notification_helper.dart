import 'package:flutter/material.dart';
import 'notification_services.dart';

class NotificationPermissionHandler extends StatefulWidget {
  final Widget child;

  const NotificationPermissionHandler({
    super.key,
    required this.child,
  });

  @override
  State<NotificationPermissionHandler> createState() =>
      _NotificationPermissionHandlerState();
}

class _NotificationPermissionHandlerState
    extends State<NotificationPermissionHandler> {
  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    final permissionStatus = await NotificationService.checkPermissionStatus();
    if (!permissionStatus) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Enable Notifications'),
            content: const Text(
              'To stay updated with your orders and cart updates, please enable notifications.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Not Now'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await NotificationService.requestPermissions();
                },
                child: const Text('Enable'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}