
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../const/assets/image_assets.dart';
import '../../../const/assets/svg_assets.dart';
import '../../../const/color.dart';
import '../../../controller/bookListing_controller.dart';
import '../../../widgets/custom_route.dart';
import '../../../widgets/custom_text.dart';
import '../../chat_screen/main_chat.dart';
import '../../nav_bar/app_nav_bar.dart';


class BuyDialogBox extends StatelessWidget {
  const BuyDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    final BookListingController bookListingController = Get.find<
        BookListingController>();
    return SizedBox(
      // height: 335.h,

        width: 404.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 159.h,
              width: 163.w,
              child: Image.asset(AppImages.doneTick),
            ),
            WorkSansCustomText(text: "Book Purchased!",
              textColor: const Color(0xff29604E),
              fontWeight: FontWeight.w700,
              fontsize: 22.sp,),
            SizedBox(height: 15.h,),
            Obx(() {
              return WorkSansCustomText(
                text: "You bought this book from Sue S. You can now chat with ${bookListingController
                    .sellerName.value} about delivering the book at school.",
                textColor: const Color(0xff010101),
                fontWeight: FontWeight.w400,
                fontsize: 14.sp,);
            }),
            SizedBox(height: 14.h,),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                  onTap: () {
                    CustomRoute1.navigateAndRemoveUntil(
                        context, BottomNavBar(), (route) => false);
                  },
                  child: Container(
                      height: 54.h,
                      width: 154.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20.r)
                      ),
                      child:
                      PoppinsCustomText(text: "Home",
                        textColor: lightWhiteColor,
                        fontWeight: FontWeight.w600,
                        fontsize: 16.sp,)
                  ),
                ),

                SizedBox(width: 15.w,),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    CustomRoute.navigateTo(context, const MainChat());
                  },
                  child: SizedBox(
                    height: 54.h,
                    width: 61.w,
                    child: SvgPicture.asset(AppIcons.msgIcon),
                  ),
                ),
              ],
            ),


          ],
        )

    );
  }
}
