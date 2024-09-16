
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            text: 'Name',
                            fontWeight: FontWeight.w500,
                            fontsize: 16.sp,
                            textColor: const Color(0xff1E1E1E),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          InputField(
                            controller: signUpController.nameController,
                            hint: 'Enter Name',
                            keyboard: TextInputType.emailAddress,
                            hintStyle:
                                TextStyle(fontSize: 16.sp, color: Colors.black54),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          LexendCustomText(
                            text: 'Email',
                            fontWeight: FontWeight.w500,
                            fontsize: 16.sp,
                            textColor: const Color(0xff1E1E1E),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          InputField(
                            controller: signUpController.emailController,
                            hint: 'Enter Email',
                            keyboard: TextInputType.emailAddress,
                            hintStyle:
                                TextStyle(fontSize: 16.sp, color: Colors.black54),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          LexendCustomText(
                            text: 'Password',
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
                              controller: signUpController.passwordController,
                              keyboard: TextInputType.text,
                              isObscure: !loginVM.loginObscure.value,
                              trailIcon: loginVM.loginObscure.value
                                  ? SvgPicture.asset(AppIcons.passwordeyeIcon)
                                  : const Icon(
                                      Icons.visibility_off_outlined,
                                      size: 20,
                                    ),
                              hintStyle: TextStyle(
                                  fontSize: 16.sp, color: Colors.black54),
                              hint: 'Enter Password',
                            );
                          }),
                          // SizedBox(
                          //   height: 8.h,
                          // ),
                          // LexendCustomText(
                          //   text: 'School Name',
                          //   fontWeight: FontWeight.w500,
                          //   fontsize: 16.sp,
                          //   textColor: const Color(0xff1E1E1E),
                          // ),
                          // SizedBox(
                          //   height: 8.h,
                          // ),
                          // Obx(() {
                          //   return Container(
                          //     height: 50.h,
                          //     width: 327.w,
                          //     alignment: Alignment.center,
                          //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                          //     decoration: BoxDecoration(
                          //         color: primaryColor.withOpacity(0.08),
                          //         borderRadius: BorderRadius.circular(20.r)),
                          //     child: DropdownButton<String>(
                          //         underline: const SizedBox.shrink(),
                          //         isExpanded: true,
                          //         value: homeController.classOption.value,
                          //         items: homeController.bookClass
                          //             .map((String option) {
                          //           return DropdownMenuItem<String>(
                          //             value: option,
                          //             child: LexendCustomText(
                          //                 text: option,
                          //                 textColor: Colors.black,
                          //                 fontWeight: FontWeight.w400),
                          //           );
                          //         }).toList(),
                          //         onChanged: (String? newValue) {
                          //           // homeController.bookClass.value=newValue!;
                          //           homeController.classOption.value = newValue!;
                          //         },
                          //         hint: const SizedBox.shrink()),
                          //   );
                          // }),
                          // Container(
                          //   padding:  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          //   width: double.infinity,
                          //   height: 58.h,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20.r),
                          //     color: Color(0xff29604E).withOpacity(0.06),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       LexendCustomText(
                          //         text: 'Harker',
                          //         fontWeight: FontWeight.w400,
                          //         fontsize: 16.sp,
                          //         textColor: Colors.black,
                          //       ),
                          //       Icon(Icons.keyboard_arrow_down)
                          //
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 38.h,
                          ),
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
                                        border: Border.all(
                                            color: primaryColor, width: 0.5)),
                                    child:
                                        signUpController.isChecked.value == true
                                            ? Icon(
                                                Icons.check,
                                                size: 14.sp,
                                              )
                                            : const SizedBox.shrink(),
                                  ),
                                ),
                                SizedBox(
                                  width: 9.w,
                                ),
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
                          SizedBox(
                            height: 38.h,
                          ),
                          CustomButton(
                            text: 'Register',
                            onPressed: () {
                              // signUpController.isChecked.value == true
                              //     ? signUpController.sentCodeEmail()
                              //     : Get.snackbar('Error',
                              //         'You must agree to terms & conditions');
                              CustomRoute.navigateTo(
                                  context,
                                  const Verification(
                                    email: '',
                                  ));
                            },
                            backgroundColor: primaryColor, // Example color
                            textColor: Colors.white,
                          ),
                          SizedBox(
                            height: 31.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LexendCustomText(
                                text: 'Already have an account?',
                                fontWeight: FontWeight.w400,
                                fontsize: 14.sp,
                                textColor:
                                    const Color(0xff3C3C43).withOpacity(0.6),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  CustomRoute.navigateTo(
                                      context, const LoginView());
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
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    )
                  ]))),
    );
  }
}
