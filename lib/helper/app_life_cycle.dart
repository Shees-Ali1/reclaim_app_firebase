
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
final UserController userController=Get.put(UserController());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // userController.updateUserPresence(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      // userController.updateUserPresence(false);
      break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }
}
