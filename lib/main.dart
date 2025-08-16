import 'package:diyar/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helpers/bloc_observer.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/networking/di/dependency_injection.dart';
import 'core/notification_services/device_token.dart';
import 'core/notification_services/notification_services.dart';
import 'core/router/app_router.dart';
import 'features/auth/ui/screen/biometric_auth_screen.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.handleNotificationNavigation(message);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase first
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await setupGetIt();
  await ScreenUtil.ensureScreenSize();
  await getIt<SharedPrefHelper >().init();
  Bloc.observer = AppBlocObserver();
  await NotificationService.initialize(navigatorKey: navigatorKey);
  await NotificationService.checkPermissionStatus();
  getIt<SharedPrefHelper >().getData(key: 'token') as String?;

  DeviceToken.setupTokenRefreshListener();
  await DeviceToken.getDeviceToken();

  final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    NotificationService.handleNotificationNavigation(initialMessage);
  }

  runApp(BiometricGate());
}

class BiometricGate extends StatefulWidget {
  const BiometricGate({super.key});

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate> {
  bool _authenticated = false;

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BiometricAuthScreen(
              onAuthSuccess: () {
                setState(() {
                  _authenticated = true;
                });
              },
            ),
          );
        },
      );
    } else {
      return Diyar(appRouter: AppRouter());
    }
  }
}


