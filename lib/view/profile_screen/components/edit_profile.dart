
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


import '../../../const/assets/image_assets.dart';
import '../../../const/assets/svg_assets.dart';
import '../../../const/color.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/login_auth_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../widgets/custom _backbutton.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_route.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/password_field.dart';
import '../../notification/notification_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final LoginAuthController loginVM = Get.find<LoginAuthController>();

  final HomeController homeController = Get.find<HomeController>();

  final UserController userController = Get.find<UserController>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = userController.userName.value;
    emailController.text = userController.userEmail.value;
    passwordController.text = userController.userPassword.value;
    userController.imageFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar1(
          homeController: homeController,
          text: 'Edit Profile',
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 17.h,
          ),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GetBuilder<UserController>(builder: (userController) {
                  return userController.imageFile == null
                      ? userController.userImage.value != null
                          ? Container(
                              height: 106.78.h,
                              width: 106.78.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        userController.userImage.value,
                                        // height: 14.h,
                                        // width: 26.w,
                                      ),
                                      fit: BoxFit.cover)),
                            )
                          : Image.asset(
                              AppImages.profile,
                              height: 106.h,
                              width: 106.w,
                            )
                      : Container(
                          height: 106.78.h,
                          width: 106.78.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: FileImage(userController.imageFile!
                                      // height: 14.h,
                                      // width: 26.w,
                                      ),
                                  fit: BoxFit.cover)),
                        );
                }),
                Positioned(
                    right: 0,
                    bottom: -5,
                    child: GestureDetector(
                        onTap: () {
                          userController.pickImage();
                        },
                        child: Icon(Icons.camera_alt_rounded,size: 35,color: primaryColor,)))
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.sp),
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
                  controller: nameController,
                  hint: 'Enter Name',
                  keyboard: TextInputType.emailAddress,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(
                  height: 8.h,
                ),
                LexendCustomText(
                  text: 'Email Address',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  textColor: const Color(0xff1E1E1E),
                ),
                SizedBox(
                  height: 8.h,
                ),
                InputField(
                  readOnly: true,
                  controller: emailController,
                  hint: 'Enter Email Address',
                  keyboard: TextInputType.emailAddress,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(
                  height: 8.h,
                ),
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
                //         items: homeController.bookClass.map((String option) {
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
                //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                //     ],
                //   ),
                // ),
                // InputField(
                //   controller: nameController,
                //   hint: 'Enter Name',
                //   keyboard: TextInputType.emailAddress,
                //   hintStyle: TextStyle(fontSize: 16.sp, color: Colors.black54),
                // ),
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
                    controller: passwordController,
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
                  height: 38.h,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r)),
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: double.infinity,
                            // height: 250.h,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                Container(
                                  width: 30.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(4.r)),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                WorkSansCustomText(
                                  text: 'Confirm changes?',
                                  fontWeight: FontWeight.w600,
                                  textColor: Colors.black,
                                  fontsize: 20.sp,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                WorkSansCustomText(
                                  text:
                                      'They will be sent to admin team to be approved again',
                                  fontWeight: FontWeight.w400,
                                  textColor: Colors.black,
                                  fontsize: 12.sp,
                                ),
                                SizedBox(
                                  height: 14.h,
                                ),
                                ElevatedButton(

                                    onPressed: () {
                                      // Check if the name has changed before updating the profile
                                      if (nameController.text !=
                                          userController.userName.value) {
                                        userController
                                            .profileUpdate(nameController)
                                            .then(
                                                (value) => // Inform the user that their request is pending approval
                                                    Get.snackbar(
                                                        'Profile Update',
                                                        'Your profile update is pending approval by the administrator.'));
                                      }

                                      // Check if the password has changed before updating the password
                                      else if (passwordController.text !=
                                          userController.userPassword.value) {
                                        userController
                                            .changePassword(passwordController);
                                      } else {
                                        Get.back();
                                        Get.back();
                                        print('No changes');
                                        Get.snackbar(
                                            'Profile Update', 'No Changes');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: Size(350.w, 80.h),
                                      minimumSize: Size(327.w, 58.h),
                                      backgroundColor: primaryColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                    ),
                                    child:
                                        Obx(() => userController.isLoading.value
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                'Yes',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ))),
                                // CustomButton(
                                //     text: 'Yes',
                                //     onPressed: () {
                                //       userController
                                //           .profileUpdate(nameController);
                                //       if (passwordController.text !=
                                //           userController.userPassword.value) {
                                //         userController
                                //             .changePassword(passwordController);
                                //       } else {
                                //         print('No changes');
                                //         Get.snackbar('Error', 'No changes');
                                //
                                //       }
                                //     },
                                //     backgroundColor: primaryColor,
                                //     textColor: whiteColor),
                                SizedBox(
                                  height: 10.h,
                                ),
                                CustomButton(
                                    text: 'Back',
                                    onPressed: () {
                                      Get.back();
                                    },
                                    backgroundColor:
                                        primaryColor.withOpacity(0.2),
                                    textColor: whiteColor),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58.h,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: LexendCustomText(
                        text: 'Change',
                        fontWeight: FontWeight.w500,
                        fontsize: 16.sp,
                        textColor: whiteColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ])));
  }
}
