import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../const/color.dart';


class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      // child: Image.asset(
      //   fit: BoxFit.cover,
      //   AppImages.backbutton,
      //   width: 38.w,
      //   height: 38.h,
      // ),
      child: Container(
        // margin: EdgeInsets.only(top: 5.h),
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CustomBackButtonMessage extends StatelessWidget {
  const CustomBackButtonMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      // child: Image.asset(
      //   fit: BoxFit.cover,
      //   AppImages.backbutton,
      //   width: 38.w,
      //   height: 38.h,
      // ),
      child: Container(
        // margin: EdgeInsets.only(top: 5.h),
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.black.withOpacity(0.22)),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}
