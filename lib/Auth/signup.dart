import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../const/assets/image_assets.dart';
import '../const/assets/svg_assets.dart';
import '../const/color.dart';
import '../controller/home_controller.dart';
import '../controller/login_auth_controller.dart';
import '../controller/sign_up_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_route.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/logo.dart';
import '../widgets/password_field.dart';
import 'login_view.dart';
import 'verification.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final SignUpController signUpController = Get.find<SignUpController>();
    final LoginAuthController loginVM = Get.find<LoginAuthController>();

    final List<String> emirates = signUpController.emirateCities.keys.toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
              Center(
                child: LexendCustomText(
                  text: 'Signup',
                  fontWeight: FontWeight.w500,
                  fontsize: 24.sp,
                  textColor: primaryColor,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: LexendCustomText(
                  text: 'Create your profile.',
                  fontWeight: FontWeight.w500,
                  fontsize: 12.sp,
                  textColor: const Color(0xff808B9A),
                ),
              ),
              SizedBox(height: 80.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LexendCustomText(
                      text: 'Name',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: const Color(0xff1E1E1E),
                    ),
                    SizedBox(height: 8.h),
                    InputField(
                      errorText: loginVM.errorText.value.isEmpty
                          ? null
                          : loginVM.errorText.value,
                      controller: signUpController.nameController,
                      hint: 'Enter Name',
                      keyboard: TextInputType.text,
                      hintStyle:
                      TextStyle(fontSize: 16.sp, color: Colors.black54),
                    ),
                    SizedBox(height: 8.h),
                    LexendCustomText(
                      text: 'Email',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: const Color(0xff1E1E1E),
                    ),
                    SizedBox(height: 8.h),
                    InputField(
                      errorText: loginVM.errorText.value.isEmpty
                          ? null
                          : loginVM.errorText.value,
                      controller: signUpController.emailController,
                      hint: 'Enter Email',
                      keyboard: TextInputType.emailAddress,
                      hintStyle:
                      TextStyle(fontSize: 16.sp, color: Colors.black54),
                    ),
                    SizedBox(height: 8.h),
                    LexendCustomText(
                      text: 'Password',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: const Color(0xff1E1E1E),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      return PasswordField(
                        errorText: loginVM.errorText.value.isEmpty
                            ? null
                            : loginVM.errorText.value,
                        onTap: () => loginVM.eyeIconLogin(),
                        controller: signUpController.passwordController,
                        keyboard: TextInputType.text,
                        isObscure: !loginVM.loginObscure.value,
                        trailIcon: loginVM.loginObscure.value
                            ? SvgPicture.asset(AppIcons.passwordeyeIcon)
                            : const Icon(
                          Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        hintStyle:
                        TextStyle(fontSize: 16.sp, color: Colors.black54),
                        hint: 'Enter Password',
                      );
                    }),
                    SizedBox(height: 8.h),
                    LexendCustomText(
                      text: 'Address',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: const Color(0xff1E1E1E),
                    ),
                    SizedBox(height: 8.h),
                    InputField(
                      controller: signUpController.poBoxController,
                      hint: 'Enter Complete Address',
                      keyboard: TextInputType.number,
                      hintStyle:
                      TextStyle(fontSize: 16.sp, color: Colors.black54),
                    ),
                    SizedBox(height: 8.h),
                    LexendCustomText(
                      text: 'Emirate',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: const Color(0xff1E1E1E),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      return Container(
                        height: 50.h,
                        width: 327.w,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: DropdownButton<String>(
                          value: signUpController.selectedEmirate.value.isEmpty
                              ? null
                              : signUpController.selectedEmirate.value,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          hint: LexendCustomText(
                            text: 'Select Emirate',
                            textColor: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          items: emirates.map((String emirate) {
                            return DropdownMenuItem<String>(
                              value: emirate,
                              child: LexendCustomText(
                                text: emirate,
                                textColor: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            signUpController.selectedEmirate.value =
                                newValue ?? 'Dubai';
                            signUpController.selectedCity.value = ''; // Reset city
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 8.h),
                    LexendCustomText(
                      text: 'City/Area',
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                      textColor: const Color(0xff1E1E1E),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      final cities = signUpController
                          .emirateCities[signUpController.selectedEmirate.value]!;
                      return Container(
                        height: 50.h,
                        width: 327.w,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: DropdownButton<String>(
                          value: signUpController.selectedCity.value.isEmpty
                              ? null
                              : signUpController.selectedCity.value,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          hint: LexendCustomText(
                            text: 'Select City/Area',
                            textColor: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          items: cities.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: LexendCustomText(
                                text: city,
                                textColor: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            signUpController.selectedCity.value =
                                newValue ?? '';
                          },
                        ),
                      );
                    }),

                    SizedBox(height: 38.h),
                    Obx(() {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              signUpController.isChecked.value =
                              !signUpController.isChecked.value;
                            },
                            child: Container(
                              width: 18.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffEEF2F1),
                                borderRadius: BorderRadius.circular(4.r),
                                border:
                                Border.all(color: primaryColor, width: 0.5),
                              ),
                              child: signUpController.isChecked.value
                                  ? Icon(Icons.check, size: 14.sp)
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          SizedBox(width: 9.w),
                          LexendCustomText(
                            text:
                            'I agree to the Terms and Conditions and Privacy Policy',
                            fontWeight: FontWeight.w500,
                            fontsize: 10.sp,
                            textColor: const Color(0xff1E1E1E),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 38.h),
                    CustomButton(
                      text: 'Register',
                      onPressed: () {
                        if (signUpController.isChecked.value) {
                          signUpController.sentCodeEmail();
                        } else {
                          Get.snackbar('Error',
                              'You must agree to terms & conditions');
                        }
                      },
                      backgroundColor: primaryColor,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 31.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LexendCustomText(
                          text: 'Already have an account?',
                          fontWeight: FontWeight.w400,
                          fontsize: 14.sp,
                          textColor: const Color(0xff3C3C43).withOpacity(0.6),
                        ),
                        SizedBox(width: 6.w),
                        GestureDetector(
                          onTap: () {
                            CustomRoute.navigateTo(context, const LoginView());
                          },
                          child: LexendCustomText(
                            text: 'Login',
                            fontWeight: FontWeight.w400,
                            fontsize: 14.sp,
                            textColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}