import 'package:get/get.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';
import 'package:reclaim_firebase_app/controller/wishlist_controller.dart';
import '../controller/chat_controller.dart';
import '../controller/home_controller.dart';
import '../controller/login_auth_controller.dart';
import '../controller/notification_controller.dart';
import '../controller/on_boarding_controller.dart';
import '../controller/order_controller.dart';
import '../controller/sign_up_controller.dart';
import '../controller/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
    Get.put(SignUpController());
    Get.put(LoginAuthController());
    Get.put(HomeController());
    Get.put(ChatController());
    Get.put(ProductsListingController());
    Get.put(UserController());
    Get.put(NotificationController());
    Get.put(OrderController());
    Get.put(WishlistController());
  }
}
