
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../const/assets/image_assets.dart';
import '../const/assets/svg_assets.dart';
import '../const/color.dart';
import '../view/nav_bar/app_nav_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_route.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/logo.dart';
import '../widgets/password_field.dart';
import '../controller/login_auth_controller.dart';
import 'register.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginAuthController loginVM = Get.find<LoginAuthController>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 100.h,
          ),
          Logo(),
          SizedBox(
            height: 25.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LexendCustomText(
                  text: 'Enter Your Email',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  textColor: const Color(0xff1E1E1E),
                ),
                SizedBox(
                  height: 8.h,
                ),
                InputField(
                  controller: loginVM.emailController,
                  hint: 'Enter Email',
                  keyboard: TextInputType.emailAddress,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(
                  height: 8.h,
                ),
                LexendCustomText(
                  text: 'Enter Your Password',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  textColor: const Color(0xff1E1E1E),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Obx(() {
                  return PasswordField(
                    onTap: () => loginVM.eyeIconLogin(),
                    controller: loginVM.passwordController,
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
                SizedBox(
                  height: 17.h,
                ),
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    // CustomRoute.navigateTo(context, const BottomNavBar());

                    if (loginVM.emailController.text.isEmpty || loginVM.passwordController.text.isEmpty) {
                      Get.snackbar(
                        "Error", // title
                        "Email and password cannot be empty", // message


                      );
                    }
                    else {
                       loginVM.loginUser();
                      // CustomRoute.navigateTo(context, const BottomNavBar());
                      // Handle successful login navigation if needed
                    }
                  },
                  backgroundColor: primaryColor, // Example color
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: 17.h,
                ),
                Center(
                  child: LexendCustomText(
                    text: 'or Login via',
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                    textColor: const Color(0xff3C3C43).withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                GestureDetector(
                  onTap: () {
                    loginVM.handleGoogleSignIn();
                  },
                  child: Center(
                    child: Container(
                      width: 154.w,
                      height: 61.h,
                      decoration: BoxDecoration(
                          color: Color(0xffE1E9E6),
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppIcons.googleIcon),
                          SizedBox(
                            width: 12.w,
                          ),
                          WorkSansCustomText(
                            text: 'Google',
                            textColor: const Color(0xff475569),
                            fontWeight: FontWeight.w400,
                            fontsize: 20.sp,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LexendCustomText(
                      text: 'Doesn’t have account?',
                      fontWeight: FontWeight.w400,
                      fontsize: 14.sp,
                      textColor: const Color(0xff3C3C43).withOpacity(0.6),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        CustomRoute.navigateTo(context, const Register());
                      },
                      child: LexendCustomText(
                        text: 'Register',
                        fontWeight: FontWeight.w400,
                        fontsize: 14.sp,
                        textColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      )),
    );
  }
}
