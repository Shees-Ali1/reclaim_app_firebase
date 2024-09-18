import 'package:get/get.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';
import 'package:reclaim_firebase_app/controller/wishlist_controller.dart';
import '../controller/home_controller.dart';
import '../controller/user_controller.dart';

final UserController userController = Get.put(UserController());
final HomeController homeController = Get.put(HomeController());
final ProductsListingController productsListingController =
    Get.put(ProductsListingController());
final WishlistController wishlistController = Get.put(WishlistController());
