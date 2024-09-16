
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../const/assets/image_assets.dart';
import '../const/color.dart';
import '../widgets/custom_route.dart';
import '../widgets/custom_text.dart';
import 'signup.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 483.h,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
             colorFilter:    ColorFilter.mode(primaryColor, BlendMode.srcIn),

                image: AssetImage(
                  AppImages.bgbackground,
                ),
                fit: BoxFit.fill)),
        child: SizedBox(
          width: 434.w,
          height: 288.h,
          child: Image.asset(
            AppImages.ilustrationRegister,
          ),
        ),
      ),
      SizedBox(
        height: 30.h,
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 33.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LexendCustomText(
              text: 'Create Your Profile',
              fontWeight: FontWeight.w400,
              fontsize: 32.sp,
              textColor: const Color(0xff273958),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LexendCustomText(
                  text: 'Now!',
                  fontWeight: FontWeight.w600,
                  fontsize: 32.sp,
                  textColor: const Color(0xff273958),
                ),
              ],
            ),
            SizedBox(
              height: 28.h,
            ),
            LexendCustomText(
              text:
                  ' Create a profile to save your learning\n progress and keep learning for free!',
              fontWeight: FontWeight.w400,
              fontsize: 14.sp,
              textColor: const Color(0xff989EA7),
            ),
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 60.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      navigator?.pop();
                    },
                    child: LexendCustomText(
                      text: 'Back',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      CustomRoute.navigateTo(context, const Signup());
                    },
                    child: Container(
                        width: 127.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(40.r)),
                        child: Center(
                          child: LexendCustomText(
                            textColor: whiteColor,
                            fontsize: 16.sp,
                            text: 'Next',
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ]));
  }
}
