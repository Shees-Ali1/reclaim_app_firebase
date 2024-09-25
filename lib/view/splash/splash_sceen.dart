
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/login_auth_controller.dart';
import '../../controller/notification_controller.dart';
import '../../controller/user_controller.dart';
import '../../helper/notification_services.dart';
import '../on_boarding/on_boarding_screens.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginAuthController loginAuthController =
      Get.find<LoginAuthController>();
  NotificationServices notificationServices = NotificationServices();
  final UserController userController = Get.find();
  final NotificationController notificationController = Get.find();
  @override
  void initState() {
    super.initState();


    Future.delayed(const Duration(seconds: 2), () {
       Get.offAll(OnBoarding());
       loginAuthController.checkUserLogin();
      notificationServices.requestNotificationPermission();
      notificationServices.firebaseInit(context);
       userController.userPurchases();
       userController.getPurchasePrice();

      userController.getDeviceStoreToken();
      FirebaseMessaging.onBackgroundMessage(notificationServices.firebaseMessagingBackgroundHandler);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset(
                  AppImages.reclaimlogo,
                )),
          ),
          // Logo()
        ],
      ),
    );
  }
}
