
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/bookListing_controller.dart';
import '../controller/chat_controller.dart';
import '../controller/home_controller.dart';
import '../controller/login_auth_controller.dart';
import '../controller/notification_controller.dart';
import '../controller/on_boarding_controller.dart';
import '../controller/order_controller.dart';
import '../controller/sign_up_controller.dart';
import '../controller/user_controller.dart';
import '../controller/wallet_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
    Get.put(SignUpController());
    Get.put(LoginAuthController());
    Get.put(HomeController());
    Get.put(ChatController());
    Get.put(BookListingController());
    Get.put(UserController());
    Get.put(NotificationController());
    Get.put(OrderController());
    Get.put(WalletController());
  }
}
