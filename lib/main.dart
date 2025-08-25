import 'package:diyar/features/home_page/data/model/apartment_search.dart';
import 'package:diyar/features/home_page/data/model/apartment_search_response.dart';
import 'package:diyar/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  await Hive.initFlutter();
  if (await Hive.boxExists('apartmentBox')) {
    await Hive.deleteBoxFromDisk('apartmentBox');
  }
  Hive.registerAdapter(ApartmentSearchResponseAdapter());
  Hive.registerAdapter(DataAdapter());
  Hive.registerAdapter(ChaletsAdapter());
  Hive.registerAdapter(PaginationAdapter());
  await Hive.openBox('apartmentBox');


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


// import 'package:diyar/my_app.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'core/helpers/bloc_observer.dart';
// import 'core/helpers/shared_pref_helper.dart';
// import 'core/networking/di/dependency_injection.dart';
// import 'core/notification_services/device_token.dart';
// import 'core/notification_services/notification_services.dart';
// import 'core/router/app_router.dart';
// import 'features/auth/ui/screen/biometric_auth_screen.dart';
// import 'firebase_options.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   NotificationService.handleNotificationNavigation(message);
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase first
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   await setupGetIt();
//   await ScreenUtil.ensureScreenSize();
//   await getIt<SharedPrefHelper>().init();
//   Bloc.observer = AppBlocObserver();
//
//   // Initialize notification services
//   await NotificationService.initialize(navigatorKey: navigatorKey);
//   await NotificationService.checkPermissionStatus();
//
//   // Get user token
//   getIt<SharedPrefHelper>().getData(key: 'token') as String?;
//
//   // Setup token refresh listener
//   DeviceToken.setupTokenRefreshListener();
//
//   // Try to get device token with a delay to allow APNs token to be ready
//   DeviceToken.getDeviceTokenWithDelay(delaySeconds: 3).then((token) {
//     if (token != null) {
//       print('✅ Device token obtained successfully in main: $token');
//     } else {
//       print('⚠️ Could not obtain device token in main');
//     }
//   }).catchError((error) {
//     print('❌ Error getting device token in main: $error');
//   });
//
//   final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//   if (initialMessage != null) {
//     NotificationService.handleNotificationNavigation(initialMessage);
//   }
//
//   runApp(BiometricGate());
// }
//
// class BiometricGate extends StatefulWidget {
//   const BiometricGate({super.key});
//
//   @override
//   State<BiometricGate> createState() => _BiometricGateState();
// }
//
// class _BiometricGateState extends State<BiometricGate> {
//   bool _authenticated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Try to get token again after widget is initialized
//     _initializeTokenAfterDelay();
//   }
//
//   void _initializeTokenAfterDelay() async {
//     // Wait a bit more after the widget is ready
//     await Future.delayed(const Duration(seconds: 5));
//     try {
//       final token = await DeviceToken.getDeviceToken();
//       if (token != null) {
//         print('✅ Token obtained after widget initialization: $token');
//       }
//     } catch (e) {
//       print('❌ Error getting token after widget initialization: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_authenticated) {
//       return ScreenUtilInit(
//         designSize: const Size(375, 812),
//         minTextAdapt: true,
//         builder: (context, child) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: BiometricAuthScreen(
//               onAuthSuccess: () {
//                 setState(() {
//                   _authenticated = true;
//                 });
//               },
//             ),
//           );
//         },
//       );
//     } else {
//       return Diyar(appRouter: AppRouter());
//     }
//   }
// }