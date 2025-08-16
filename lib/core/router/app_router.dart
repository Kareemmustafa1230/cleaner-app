import 'package:diyar/core/router/routers.dart';
import 'package:diyar/features/home/ui/screen/home.dart';
import 'package:diyar/features/login/ui/screen/login.dart';
import 'package:diyar/features/home_page/ui/screen/home_screen.dart';
import 'package:diyar/features/setting/ui/screen/settings_screen.dart';
import 'package:diyar/features/upload/ui/screen/upload_screen.dart';
import 'package:flutter/material.dart';



class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (context) => const Home());

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case Routes.setting:
        return MaterialPageRoute(builder: (context) => const SettingsScreen());

      case Routes.uploadScreen:
        return MaterialPageRoute(builder: (context) => const UploadScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
