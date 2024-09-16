import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRoute {
  static void navigateTo(BuildContext context, Widget route) {
    Get.to(
      route,
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}

class CustomRoute1 {
  static void navigateAndRemoveUntil(
      BuildContext context, Widget route, RoutePredicate predicate) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => route),
      predicate,
    );
  }
}
