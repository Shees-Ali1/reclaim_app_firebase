import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/helper/loading.dart';

import '../../const/assets/image_assets.dart';
import '../../const/assets/svg_assets.dart';
import '../../const/color.dart';

import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_route.dart';
import '../../widgets/custom_text.dart';
import '../home_screen/book_details_screen.dart';
import '../home_screen/home_screen_books.dart';
import '../notification/notification_screen.dart';
import 'book_sell_screen.dart';
import 'list_sell_book_screen.dart';

class SellScreenMain extends StatefulWidget {
  const SellScreenMain({super.key});

  @override
  State<SellScreenMain> createState() => _SellScreenMainState();
}

class _SellScreenMainState extends State<SellScreenMain> {
  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.find<UserController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productsListingController.fetchUserProductListing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          homeController: homeController,
          text: 'Listed Items',
        ),
        body: Obx(() => productsListingController.isLoading.value == false
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Obx(() => productsListingController.mySellListings.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 66.h,
                                ),
                                InterCustomText(
                                  text: 'No items listed for sale',
                                  textColor: lightBlackColor,
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                SizedBox(
                                  height: 223.h,
                                  width: 186.w,
                                  child: Image.asset(
                                    AppImages.sellMan,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 24.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // userController.verified.value == true
                                    //     ?
                                    Get.to(
                                      const ListSellBookScreen(
                                        comingFromEdit: false,
                                      ),
                                      transition: Transition.fade,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeIn,
                                    );
                                    //     : Get.snackbar('Your Profile is UnderReview',
                                    //                    'Wait for Admin Approval',
                                    //                    colorText: Colors.black,
                                    //                    backgroundColor: Colors.white
                                    // );
                                  },
                                  child: Container(
                                      height: 39.h,
                                      width: 205.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: FittedBox(
                                          child: InterCustomText(
                                        text: "Sell your first item here!",
                                        textColor: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontsize: 14.sp,
                                      ))),
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              const ListSellBookScreen(
                                                comingFromEdit: false,
                                              ),
                                              transition: Transition.fade,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                          },
                                          child: Container(
                                              height: 39.h,
                                              width: 142.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r)),
                                              child: FittedBox(
                                                  child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  InterCustomText(
                                                    text: "Sell a new item",
                                                    textColor: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontsize: 14.sp,
                                                  ),
                                                ],
                                              ))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  // Modify your GridView.builder
                                  GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          8.0, // Horizontal space between items
                                      mainAxisSpacing:
                                          8.0, // Vertical space between items
                                      childAspectRatio:
                                          0.75, // Aspect ratio of each item
                                    ),
                                    clipBehavior: Clip.none,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: productsListingController
                                        .mySellListings.length,
                                    itemBuilder: (context, index) {
                                      final product = productsListingController
                                          .mySellListings[index];

                                      // Ensure the productImages field is handled correctly (e.g., showing the first image)
                                      String firstProductImage = '';
                                      if (product['productImages'] is List &&
                                          product['productImages'].isNotEmpty) {
                                        firstProductImage =
                                            product['productImages']
                                                [0]; // Access the first image
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            BookDetailsScreen(
                                              index: index,
                                              comingfromSellScreen: true,
                                              bookDetail:
                                                  product, // Pass the product data correctly
                                            ),
                                            transition: Transition.fade,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn,
                                          );
                                        },
                                        child: productCard(
                                          product['listingId'],
                                          product['productCondition'],
                                          product['brand'],
                                          product['productName'],
                                          product['productPrice'],
                                          firstProductImage, // Pass the first image to the productCard
                                          context,
                                          homeController,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ))
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ))));
  }
}
