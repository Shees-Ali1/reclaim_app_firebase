import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/view/wishlist/wishlist.dart';

import '../../const/assets/svg_assets.dart';
import '../../const/color.dart';
import '../../controller/login_auth_controller.dart';
import '../../controller/user_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_route.dart';
import '../../widgets/custom_text.dart';
import '../my_orders/my_orders.dart';
import '../profile_screen/components/customer_support.dart';
import '../profile_screen/components/edit_profile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    final LoginAuthController loginAuthController =
        Get.find<LoginAuthController>();
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 32.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 28.w,
                ),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              userController.userImage.value,
                            ),
                            fit: BoxFit.cover)),
                    height: 76.h,
                    width: 76.w,
                  );
                }),
                SizedBox(
                  width: 20.w,
                ),
                SizedBox(
                    width: 160.w,
                    child: LexendCustomText(
                      text: userController.userName.value,
                      fontWeight: FontWeight.w400,
                      fontsize: 20.sp,
                      textColor: blackTitleColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            DrawerItemsWidget(
              text: 'Edit Profile',
              image: AppIcons.profileIcon,
              onTap: () {
                CustomRoute.navigateTo(context, const EditProfile());
              },
            ),
            DrawerItemsWidget(
              text: 'Favourites',
              image: AppIcons.favourite,
              onTap: () {
               CustomRoute.navigateTo(context, const Wishlist());
              },
            ),
            DrawerItemsWidget(
              text: 'My Orders',
              image: AppIcons.terms,
              onTap: () {
                CustomRoute.navigateTo(context, const MyOrders());
              },
            ),
            // const DrawerItemsWidget(
            //   text: 'Change Password',
            //   image: AppIcons.password,
            // ),
            DrawerItemsWidget(
              text: 'About Reclaim',
              image: AppIcons.privacy,
              onTap: () {
                // CustomRoute.navigateTo(context, CustomerSupport());
              },
            ),
            DrawerItemsWidget(
              onTap: () {
                showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 290.h,
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Container(
                              width: 48.w,
                              height: 5.h,
                              decoration:
                                  const BoxDecoration(color: Color(0xffCDCFD0)),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            LexendCustomText(
                              text: 'Delete Account?',
                              textColor: const Color(0xff090A0A),
                              fontWeight: FontWeight.w700,
                              fontsize: 24.sp,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            LexendCustomText(
                              text: 'Are you sure want to delete this account?',
                              textColor: const Color(0xff090A0A),
                              fontWeight: FontWeight.w400,
                              fontsize: 16.sp,
                            ),
                            SizedBox(
                              height: 37.h,
                            ),
                            CustomButton(
                                text: 'Yes',
                                onPressed: () async {
                                  await userController.deleteAccont();
                                },
                                backgroundColor: const Color(0xffE60000),
                                textColor: whiteColor),
                            SizedBox(
                              height: 22.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: LexendCustomText(
                                text: 'Cancel',
                                textColor: const Color(0xff202325),
                                fontWeight: FontWeight.w500,
                                fontsize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              text: 'Delete Account',
              image: AppIcons.deleteaccount,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    await loginAuthController.logOut();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      SizedBox(
                        width: 15.w,
                      ),
                      WorkSansCustomText(
                        textColor: const Color(0xff040415),
                        fontWeight: FontWeight.w700,
                        fontsize: 16.sp,
                        text: 'Log Out',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30.w,
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class DrawerItemsWidget extends StatelessWidget {
  final String text;
  final String image;
  final void Function()? onTap;

  const DrawerItemsWidget(
      {super.key, required this.text, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 17.h),
        child: Row(
          children: [
            SizedBox(
              height: 36.7.h,
              width: 36.7.w,
              child: SvgPicture.asset(image),
            ),
            SizedBox(
              width: 31.09.w,
            ),
            WorkSansCustomText(
              textColor: const Color(0xff040415),
              fontWeight: FontWeight.w500,
              fontsize: 16.sp,
              text: text,
            ),
          ],
        ),
      ),
    );
  }
}
