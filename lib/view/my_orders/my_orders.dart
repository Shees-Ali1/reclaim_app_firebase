
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final List<String> items = [
      'Size UK 14',
      'Women',
      'Barely Used',
      'TopShop',

    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Orders',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.h),
              width: 338.w,
              // height: 123.h,
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 78.h,
                          width: 89.w,
                          child: Image.asset(AppImages.image2)),
                      SizedBox(
                        width: 7.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterCustomText(
                            text: 'Mango',
                            textColor: Color(0xff9B9B9B),
                            fontWeight: FontWeight.w400,
                            fontsize: 11.sp,
                          ),
                          InterCustomText(
                            text: 'T-Shirt SPANISH',
                            textColor: Color(0xff222222),
                            fontWeight: FontWeight.w600,
                            fontsize: 16.sp,
                          ),
                          InterCustomText(
                            text: '20 Aed',
                            textColor: Color(0xff222222),
                            fontWeight: FontWeight.w500,
                            fontsize: 14.sp,
                          ),
                          InterCustomText(
                            text: '10 Mar 2024',
                            textColor: Color(0xff9B9B9B),
                            fontWeight: FontWeight.w400,
                            fontsize: 11.sp,
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: 74.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11.r),
                            color: primaryColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InterCustomText(
                              text: 'Order Price',
                              textColor: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontsize: 11.sp,
                            ),
                            SizedBox(height: 3.h,),
                            InterCustomText(
                              text: '19 Aed',
                              textColor: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontsize: 11.sp,
                            ),
                            SizedBox(height: 3.h,),

                            Container(
                              width: 49.w,
                              height: 15.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: Color(0xffF0FFE0)),
                              child: Center(
                                child: InterCustomText(
                                  text: 'Ordered',
                                  textColor: Color(0xff11CF0A),
                                  fontWeight: FontWeight.w500,
                                  fontsize: 10.sp,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h,),
                  Wrap(
                    spacing: 3, // space between items
                    runSpacing: 10, // space between rows
                    children: items.map((size) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // homeController.selectedSize.value = size;
                            },
                            child: Container(
                              // width: 76.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,   vertical: 6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),

                                color:
                                  primaryColor.withOpacity(0.10),// Highlight background color for selected size
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MontserratCustomText(
                                      text: size,
                                      textColor:
                                         primaryColor, // Change as needed
                                      fontWeight: FontWeight.w500,
                                      fontsize: 10.sp,
                                    ),
                                  ],
                                ),
                              ),
                            )),

                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
