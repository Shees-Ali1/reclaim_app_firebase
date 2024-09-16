
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../const/color.dart';
import '../../../controller/home_controller.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_textfield.dart';

class CustomerSupport extends StatelessWidget {
  const CustomerSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar1(
          homeController: homeController,
          text: 'Customer Support',
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LexendCustomText(
                  text: 'Topic',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  textColor: const Color(0xff1E1E1E),
                ),
                SizedBox(
                  height: 8.h,
                ),
                InputField(
                  // controller: emailController,
                  hint: 'Enter Your Topic',
                  keyboard: TextInputType.emailAddress,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(
                  height: 8.h,
                ),
                LexendCustomText(
                  text: 'Message',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  textColor: const Color(0xff1E1E1E),
                ),
                SizedBox(
                  height: 8.h,
                ),
                InputField(
                  contentPadding: EdgeInsets.symmetric(vertical: 70.h,horizontal: 15.w),

                  // controller: emailController,
                  hint: 'Enter Your Message',
                  keyboard: TextInputType.emailAddress,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  width: double.infinity,
                  height: 58.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: LexendCustomText(
                      text: 'Send',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
