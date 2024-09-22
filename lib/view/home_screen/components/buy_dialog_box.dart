import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';

import '../../../const/assets/image_assets.dart';
import '../../../const/assets/svg_assets.dart';
import '../../../const/color.dart';

import '../../../widgets/custom_route.dart';
import '../../../widgets/custom_text.dart';
import '../../chat_screen/main_chat.dart';
import '../../nav_bar/app_nav_bar.dart';

class BuyDialogBox extends StatefulWidget {
  final String productId;
  final String buyerId;
  const BuyDialogBox({super.key, required this.productId, required this.buyerId});

  @override
  State<BuyDialogBox> createState() => _BuyDialogBoxState();
}

class _BuyDialogBoxState extends State<BuyDialogBox> {
  final ProductsListingController productsListingController =
  Get.find<ProductsListingController>();
  @override
  Widget build(BuildContext context) {

    return SizedBox(
        // height: 335.h,

        width: 404.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 159.h,
              width: 163.w,
              child: Image.asset(
                AppImages.doneTick,
                color: primaryColor,
              ),
            ),
            WorkSansCustomText(
              text: "Product Purchased!",
              textColor: primaryColor,
              fontWeight: FontWeight.w700,
              fontsize: 22.sp,
            ),
            SizedBox(
              height: 15.h,
            ),
            Obx(() {
              return WorkSansCustomText(
                text:
                    "You bought this product from ${productsListingController.sellerName.value}. You can now chat with seller about delivering the product.",
                textColor: const Color(0xff010101),
                fontWeight: FontWeight.w400,
                fontsize: 14.sp,
              );
            }),
            SizedBox(
              height: 14.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    CustomRoute1.navigateAndRemoveUntil(
                        context, BottomNavBar(), (route) => false);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 54.h,
                      // width: 154.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: PoppinsCustomText(
                        text: "Home",
                        textColor: lightWhiteColor,
                        fontWeight: FontWeight.w600,
                        fontsize: 16.sp,
                      )),
                ),
                SizedBox(width: 15,),
                GestureDetector(
                  onTap: () {
                    showDialog(

                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController _reviewController = TextEditingController();

                        return AlertDialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 10),
                          title: Text('Submit Your Review'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Rating Section (using 1-5 stars) with GetBuilder for real-time updates
                              GetBuilder<ProductsListingController>(
                                builder: (controller) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      return IconButton(
                                        // iconSize: 20,
                                        icon: Icon(
                                          index < productsListingController.rating ? Icons.star : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          productsListingController.updateRating(index + 1); // Update rating on tap
                                        },
                                      );
                                    }),
                                  );
                                },
                              ),
                              // TextField for review
                              TextField(
                                controller: _reviewController,
                                decoration: InputDecoration(hintText: 'Write your review...'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Submit the review with the current rating and review text
                                await Get.find<ProductsListingController>().submitReviewToFirestore(
                                    widget.productId,
                                    Get.find<ProductsListingController>().rating,
                                    _reviewController.text,
                                    widget.buyerId
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 54.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: PoppinsCustomText(
                      text: "Review",
                      textColor: lightWhiteColor,
                      fontWeight: FontWeight.w600,
                      fontsize: 16.sp,
                    ),
                  ),
                ),


                // SizedBox(width: 15.w,),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //     CustomRoute.navigateTo(context, const MainChat());
                //   },
                //   child: SizedBox(
                //     height: 54.h,
                //     width: 61.w,
                //     child: SvgPicture.asset(AppIcons.msgIcon),
                //   ),
                // ),
              ],
            ),
          ],
        ));
  }
}
