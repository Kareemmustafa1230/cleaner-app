import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../language/app_localizations.dart';
import '../theme/Color/color_extension.dart';
import 'custom_transitions.dart';

extension Navigation on BuildContext {
  //color
  MyColors get color => Theme.of(this).extension<MyColors>()!;
  // Get localized text
  String translate(String langKey) {
    return AppLocalizations.of(this)!.translate(langKey).toString();
  }

  // Push a named route
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  // Push and replace the current route
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  // Push a named route and remove all previous routes until a specific one
  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  // Push a new screen with a custom transition
  Future<dynamic> pushWithTransition({
    required Widget screen,
    PageTransitionType transitionType = PageTransitionType.rightToLeft,
    Duration duration = const Duration(milliseconds: 400),
    Duration reverseDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.of(this).push(
      PageTransition(
        type: transitionType,
        child: screen,
        duration: duration,
        reverseDuration: reverseDuration,
        curve: curve,
      ),
    );
  }

  // Push with SlideTransition animation
  Future<dynamic> pushWithSlideTransition({
    required Widget screen,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
    Offset begin = const Offset(1.0, 0.0), // Slide from right
    Offset end = Offset.zero,
  }) {
    return Navigator.of(this).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  // Push with custom slide from right
  Future<dynamic> pushWithSlideFromRight(Widget screen) {
    return Navigator.of(this).push(CustomTransitions.slideFromRight(screen));
  }

  // Push with custom slide from left
  Future<dynamic> pushWithSlideFromLeft(Widget screen) {
    return Navigator.of(this).push(CustomTransitions.slideFromLeft(screen));
  }

  // Push with custom slide from bottom
  Future<dynamic> pushWithSlideFromBottom(Widget screen) {
    return Navigator.of(this).push(CustomTransitions.slideFromBottom(screen));
  }

  // Push with custom slide from top
  Future<dynamic> pushWithSlideFromTop(Widget screen) {
    return Navigator.of(this).push(CustomTransitions.slideFromTop(screen));
  }

  // Push with fade scale transition
  Future<dynamic> pushWithFadeScale(Widget screen) {
    return Navigator.of(this).push(CustomTransitions.fadeScale(screen));
  }

  // Push with rotation transition
  Future<dynamic> pushWithRotation(Widget screen) {
    return Navigator.of(this).push(CustomTransitions.rotation(screen));
  }

  Future<dynamic> pushWithPersistentBottomNavBar(Widget screen) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  // Push and replace a screen with a custom transition
  Future<dynamic> pushReplacementWithTransition({
    required Widget screen,
    bool withNavBar = false, // إضافة معامل withNavBar
    PageTransitionType transitionType = PageTransitionType.rightToLeft,
    Duration duration = const Duration(milliseconds: 400),
    Duration reverseDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.of(this).pushReplacement(
      PageTransition(
        type: transitionType,
        child: screen,
        duration: duration,
        reverseDuration: reverseDuration,
        curve: curve,
      ),
    );
  }

  // PushReplacement with SlideTransition animation
  Future<dynamic> pushReplacementWithSlideTransition({
    required Widget screen,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset begin = const Offset(1.0, 0.0), // Slide from right
    Offset end = Offset.zero,
  }) {
    return Navigator.of(this).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  // Pop the current route
  void pop([dynamic result]) => Navigator.of(this).pop(result);

  // Pop until a certain condition is met
  void popUntil(RoutePredicate predicate) =>
      Navigator.of(this).popUntil(predicate);

  // Check if a route can pop
  bool canPop() => Navigator.of(this).canPop();

  // Push and clear stack until the initial route
  Future<dynamic> pushAndClearStack(Widget screen) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
          (route) => false,
    );
  }

  // General Navigator State Accessor
  NavigatorState get navigator => Navigator.of(this);
}

// Extension for String utilities
extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

// Extension for List utilities
extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
